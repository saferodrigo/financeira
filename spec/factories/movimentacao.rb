# frozen_string_literal: true

FactoryBot.define do
  factory :movimentacao, class: Movimentacao do
    valor { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    tipo { 0 }

    association :conta
  end
end
