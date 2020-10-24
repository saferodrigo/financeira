class SessionsController < ApplicationController
  before_action :authorize, except: %i[new create]
  protect_from_forgery with: :exception
  before_action :block_access, except: %i[destroy]
  include SessionsHelper

  def new; end

  def create
    @usuario = Usuario.find_by(cpf: params[:session][:cpf])

    if @usuario&.authenticate(params[:session][:password])
      sign_in(@usuario)
      redirect_to @usuario
    else
      sign_out
      flash[:error] = "CPF ou senha inválidos"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def authorize
    redirect_to root_url unless logged_in?
  end

  def correct_user?
    @usuario = Usuario.find(params[:id])

    redirect_to usuario_path(@usuario) unless current_user == @usuario
  end
end
