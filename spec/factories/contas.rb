# frozen_string_literal: true

FactoryBot.define do
  factory :conta do
    saldo { '9.9' }
    numero { Faker::Alphanumeric.numeric(number: 6) }
    association :usuario
    association :movimentacoes
  end
end
