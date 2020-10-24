class UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[show edit update destroy]
  before_action :correct_user?, only: %i[edit update destroy]

  def index
    flash[:error] = 'Acesso negado!'
    redirect_to root_path
  end

  def show; end

  def new
    @usuario = Usuario.new
  end

  def edit; end

  def create
    @usuario = Usuario.new(usuario_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: t('messages.success', model: Usuario.model_name.human) }
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
        format.html { redirect_to @usuario, notice: t('messages.success', model: Usuario.model_name.human) }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    sign_out
    redirect_to root_path
  end

  private

    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    def usuario_params
      params.require(:usuario).permit(:nome, :cpf, :password, :password_confirmation)
    end
end
