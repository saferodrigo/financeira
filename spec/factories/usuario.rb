# frozen_string_literal: true

FactoryBot.define do
  factory :usuario, class: Usuario do
    nome { Faker::Name.name }
    cpf { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    # password_digest { Faker::Alphanumeric.alphanumeric(number: 6) }
    password { Faker::Alphanumeric.alphanumeric(number: 6) }
  end
end
