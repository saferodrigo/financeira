# frozen_string_literal: true

FactoryBot.define do
  factory :conta, class: Conta do
    ativa { Faker::Boolean.boolean }
    saldo { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    numero { Faker::Number.number(digits: 6) }

    association :usuario
  end
end
