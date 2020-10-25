json.extract! conta, :id, :usuario_id, :saldo, :numero, :ativa, :created_at, :updated_at
json.url conta_url(conta, format: :json)
