require 'cgi'

module ApplicationHelper
  def custom_bootstrap_flash
    flash_messages = []
    tipo = 'warning'

    flash.each do |type, message|
      tipo = 'success' if %w[success notice].include?(type)
      tipo = 'error' if %w[error alert].include?(type)

      message = CGI.escapeHTML(message) # escapa aspas simples e/ou duplas

      text = message.to_s
      flash_messages << text.html_safe if message
    end

    return if flash_messages.empty?

    flash_messages = flash_messages.join('\n')

    "<script>$(document).ready(function() {
      swal({
        title: 'Atenção!',
        text: '#{flash_messages}',
        icon: '#{tipo}'
      })
    });</script>".html_safe
  end

  def loading_modal_before_ajax
    "<script>

      document.body.addEventListener('ajax:before', function(event) {
        document.getElementById('modal-carregando').modal({
          backdrop: 'static',
          keyboard: false,
          show: true
        })
      })

    </script>".html_safe
  end

  def normaliza_money(money)
    return if money.blank?

    money.to_s.gsub('R$', '').gsub('.', '').gsub(',', '.')
  end

  def acesso_negado
    flash[:error] = 'Acesso Negado!'
    sign_out
    redirect_to root_path
  end
end
