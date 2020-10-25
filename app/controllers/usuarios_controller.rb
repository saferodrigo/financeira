require 'cpf_cnpj'

class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[show edit update saldo encerrar_conta]
  before_action :validar_permissao, only: %i[edit update show]

  include SessionsHelper
  include ActionView::Helpers::NumberHelper

  def index
    flash[:error] = 'Acesso negado!'
    redirect_to root_path
  end

  def show; end

  def new
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
end
