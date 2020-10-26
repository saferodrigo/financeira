require 'cpf_cnpj'

class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[show edit update encerrar_conta movimentacao]
  before_action :validar_permissao, only: %i[edit update show]

  include ApplicationHelper
  include SessionsHelper
  include ActionView::Helpers::NumberHelper

  def index
    flash[:error] = 'Acesso negado!'
    redirect_to root_path
  end

  def show; end

  def new
    sign_out
    flash[:info] = 'Cliente desconectado.' if current_user.present?
    @usuario = Usuario.new
  end

  def edit; end

  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        sign_in(@usuario)

        format.html { redirect_to @usuario, notice: 'Conta cadastrada com sucesso.' }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: 'Conta alterada com sucesso.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def gerar_cpf
    @cpf = CPF.generate(true)
  end

  def usuario_por_cpf
    @dados = {}
    usuario = Usuario.find_by(cpf: params[:cpf])

    return unless usuario.present?

    @dados = {
      presente: true,
      usuario: {
        id: usuario.id,
        nome: usuario.nome,
        cpf: usuario.cpf_formatado,
        conta: {
          id: usuario.conta&.id,
          numero: usuario.conta&.numero_formatado
        }
      }
    }
  end

  def encerrar_conta
    respond_to do |format|
      if @usuario.encerrar_conta
        format.html { redirect_to @usuario, success: 'Conta encerrada com sucesso' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def movimentacao
    if params[:id].blank? || params[:tipo].blank? || params[:valor].blank?
      flash[:error] = 'Parâmetros inválidos'
      redirect_to @usuario
    end

    Usuario.transaction do
      valor = normaliza_money(params[:valor])
      valor = valor.to_f
      sucesso = false
      msg = ''
      msg_error = validar_movimentacoes(tipo: params[:tipo], valor: valor, conta: @usuario&.conta)

      unless msg_error.present?

        case params[:tipo]
        when 'deposito'
          sucesso = @usuario.depositar(valor)
          msg = 'Depósito efetuado com sucesso.'

        when 'saque'
          sucesso = @usuario.sacar(valor)
          msg = 'Saque efetuado com sucesso.'

        when 'transferencia'
          sucesso = @usuario.transferir(valor, params[:conta_id])
          msg = 'Transferência efetuada com sucesso.'
        end

      end

      if sucesso
        flash[:success] = msg
      else
        flash[:error] = msg_error.any? ? msg_error.join('/n') : 'Não foi possível efetuar esta operação.'
      end

      redirect_to @usuario
    end
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])
  end

  def usuario_params
    params.require(:usuario).permit(
      :nome, :cpf, :password, :password_confirmation,
      conta_attributes: %i[id ativa numero saldo]
    )
  end

  def validar_permissao
    usuario = Usuario.find(params[:id])

    return if current_user == usuario

    flash[:error] = 'Acesso Negado!'
    sign_out
    redirect_to root_path
  end

  def validar_movimentacoes(tipo: '', valor: 0, conta: nil)
    msg = []

    if tipo.present?
      msg << "#{tipo.titleize} deve ser positivo." if valor.negative?
      msg << "#{tipo.titleize} deve ser maior que zero." if valor.zero?
      msg << 'Saldo insuficiente.' if %w[saque transferencia].include?(tipo) && valor.to_f > conta&.saldo&.to_f
    end

    msg
  end
end
