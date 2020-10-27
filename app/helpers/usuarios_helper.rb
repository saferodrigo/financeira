module UsuariosHelper
  def titulo_modal_extrato(numero_conta: nil, data_inicio: nil, data_fim: nil)
    return '' if numero_conta.blank? || data_inicio.blank? || data_fim.blank?

    titulo_modal = "Extrato da conta n° #{numero_conta}"
    titulo_modal += " no dia #{I18n.l(data_inicio)}" if data_inicio.to_date == data_fim.to_date
    titulo_modal += " de #{I18n.l(data_inicio)} à #{I18n.l(data_fim)} " if data_inicio.to_date != data_fim.to_date

    titulo_modal
  end
end
