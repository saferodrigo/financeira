require 'cpf_cnpj'

class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[show edit update encerrar_conta movimentacao]
  before_action :validar_permissao, only: %i[edit update show]

  include ApplicationHelper
  include SessionsHelper
  include ActionView::Helpers::NumberHelper

  def index
    acesso_negado
  end

  def show; end

  def new
    flash[:alert] = 'Cliente desconectado.' if current_user.present?
    sign_out
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
          numero: usuario.conta&.numero_formatado&.to_s,
          ativa: usuario.conta&.ativa
        }
      }
    }
  end

  def encerrar_conta
    respond_to do |format|
      if @usuario.encerrar_conta
        format.html { redirect_to @usuario, notice: 'Conta encerrada com sucesso' }
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
      redirect_to root_path
    end

    Usuario.transaction do
      valor = normaliza_money(params[:valor])
      valor = valor.to_f
      conta_transferencia = Conta.find(params[:conta_id]) if params[:conta_id].present?
      sucesso = false
      msg = ''
      msg_error = validar_movimentacoes(tipo: params[:tipo], valor: valor, conta: @usuario&.conta)

      unless msg_error.present?

        case params[:tipo]
        when 'deposito'
          sucesso = @usuario.depositar(valor)
          msg = "Depósito de #{number_to_currency(valor)} efetuado com sucesso."

        when 'saque'
          sucesso = @usuario.saque(valor)
          msg = "Saque de #{number_to_currency(valor)} efetuado com sucesso."

        when 'transferencia'
          sucesso = @usuario.transferir(valor: valor, conta_id_transferencia: conta_transferencia&.id)
          msg = "Transferência para #{conta_transferencia.usuario.nome.titleize} de #{number_to_currency(valor)} efetuada com sucesso."
        end

      end

      respond_to do |format|
        if sucesso
          format.html { redirect_to @usuario, notice: msg }
          format.json { render :show, status: :ok, location: @usuario }
        else
          format.html { render :show, error: msg_error.any? ? msg_error.join('/n') : 'Não foi possível efetuar esta operação.' }
          format.json { render show: msg_error.any? ? msg_error.join('/n') : 'Não foi possível efetuar esta operação.', status: :unprocessable_entity, location: @usuario }
        end
      end
    end
  end

  def search_extrato
    @data_inicio = params[:data_inicio]&.to_date
    @data_fim = params[:data_fim]&.to_date
    @data_inicio ||= Date.today
    @data_fim ||= Date.today
    @usuario = Usuario.find(params[:id])

    @extrato = @usuario.conta.movimentacoes
                       .by_periodo(@data_inicio, @data_fim)
                       .group_by { |m| m.created_at&.to_date }

    return if params[:id].present? && Usuario.exists?(params[:id])

    acesso_negado
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id]) if Usuario.exists?(params[:id])

    return if params[:id].present? && Usuario.exists?(params[:id])

    acesso_negado
  end

  def usuario_params
    params.require(:usuario).permit(
      :id, :nome, :cpf, :password, :password_confirmation,
      conta_attributes: %i[id ativa numero saldo]
    )
  end

  def validar_permissao
    usuario = Usuario.find(params[:id]) if params[:id].present?

    return if current_user == usuario

    acesso_negado
  end

  def validar_movimentacoes(tipo: '', valor: 0, conta: nil)
    msg = []

    if tipo.present?
      msg << "#{Movimentacao.tipos[tipo]} deve ser positivo." if valor.negative?
      msg << "#{Movimentacao.tipos[tipo]} deve ser maior que zero." if valor.zero?
      msg << 'Saldo insuficiente.' if %w[saque].include?(tipo) && (valor.to_f) > conta&.saldo&.to_f
      msg << 'Saldo insuficiente.' if %w[transferencia].include?(tipo) && (valor.to_f + Conta.valor_taxa_transferencia(valor)) > conta&.saldo&.to_f
    end

    msg
  end
end
