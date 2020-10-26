require 'cgi'

module ApplicationHelper
  def custom_bootstrap_flash
    flash_messages = []

    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      message = CGI.escapeHTML(message) # escapa aspas simples e/ou duplas

      text = "toastr.#{type}('#{message}', { timeOut: 5000 });"
      flash_messages << text.html_safe if message
    end
    flash_messages = flash_messages.join('\n')

    "<script>$(document).ready(function() { #{flash_messages} });</script>".html_safe
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
end
