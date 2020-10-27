# frozen_string_literal: true

FactoryBot.define do
  factory :movimentacao do
    valor { '9.99' }
    tipo { 1 }

    association :conta
  end
end
