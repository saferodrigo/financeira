# frozen_string_literal: true

require 'rails_helper'
require 'cpf_cnpj'

RSpec.describe UsuariosController, type: :controller do
  render_views

  let(:conta_attributes) do
    attributes_for(:conta)
  end

  let(:movimentacao_attributes) do
    attributes_for(:movimentacao)
  end

  let(:valid_attributes) do
    attributes_for(:usuario)
  end

  let(:invalid_attributes) do
    attributes_for(:usuario, cpf: '0123213123')
  end

  describe 'GET #show' do
    subject { get :show, params: valid_attributes }

    it { expect(response).to have_http_status(200) }
  end

  describe 'GET #new' do
    subject { get :new, params: {} }

    it { expect(response).to have_http_status(200) }
    it { route(:get, '/usuarios/new').to(controller: :usuarios, action: :new) }
  end

  describe 'GET #edit' do
    subject { get :edit, params: valid_attributes }

    it { expect(response).to have_http_status(200) }

    it 'GET route #edit' do
      usuario1 = Usuario.create! valid_attributes
      route(:get, "/usuarios/#{usuario1.to_param}").to(controller: :usuarios, action: :edit, id: usuario1.to_param)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: valid_attributes }

    it { expect(response).to have_http_status(200) }
    it { route(:post, '/usuarios').to(controller: :usuarios, action: :create) }
  end

  describe 'POST #create invalid_attributes' do
    subject { post :create, params: invalid_attributes }

    it { expect(response).to have_http_status(200) }
    it { route(:post, '/usuarios').to(controller: :usuarios, action: :create) }
  end

  describe 'PUT #update' do
    subject { put :update, params: valid_attributes }

    it { expect(response).to have_http_status(200) }
    it { route(:put, '/usuarios').to(controller: :usuarios, action: :update) }
  end

  describe 'PUT #update invalid_attributes' do
    subject { put :update, params: invalid_attributes }

    it { expect(response).to have_http_status(200) }
    it { route(:put, '/usuarios').to(controller: :usuarios, action: :update) }
  end

  describe 'GET #encerrar_conta' do
    subject { get :encerrar_conta, params: valid_attributes }

    it { expect(response).to have_http_status(200) }

    it 'route encerrar conta' do
      usuario1 = Usuario.create! valid_attributes
      route(:get, "/usuarios/#{usuario1.to_param}/encerrar_conta").to(controller: :usuarios, action: :encerrar_conta)
    end

    it 'action encerrar conta' do
      usuario1 = Usuario.create! valid_attributes
      conta1 = Conta.new(conta_attributes)
      conta1.usuario_id = usuario1.id
      conta1.save!

      usuario1.encerrar_conta

      expect(response).to be_successful
    end
  end

  describe 'GET action #movimentacao' do
    subject { get :encerrar_conta, params: valid_attributes }

    it { expect(response).to have_http_status(200) }

    it 'route action movimentacao' do
      usuario1 = Usuario.create! valid_attributes
      route(:get, "/usuarios/#{usuario1.to_param}/movimentacao").to(controller: :usuarios, action: :encerrar_conta)
    end

    it 'DEPOSITAR R$ 100,00' do
      valor = 100.0
      usuario1 = Usuario.create! valid_attributes
      conta1 = Conta.new(conta_attributes)
      conta1.usuario_id = usuario1.id
      conta1.save!

      depositou = usuario1.depositar(valor)
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.tipo = :deposito
      movimentacao1.save!

      expect(depositou).to be true
    end

    it 'solicitar SALDO' do
      valor = 100.0
      usuario1 = Usuario.create! valid_attributes
      conta1 = Conta.new
      conta1.saldo = 0
      conta1.ativa = true
      conta1.usuario_id = usuario1.id
      conta1.numero = Faker::Number.number(digits: 6)
      conta1.save!

      usuario1.depositar(valor)
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.tipo = :deposito
      movimentacao1.save!

      expect(usuario1.conta.saldo.to_f).to eq(valor)
    end

    it 'SAQUE R$ 10,00' do
      valor = 10.0
      usuario1 = Usuario.create! valid_attributes

      conta1 = Conta.new(conta_attributes)
      conta1.usuario_id = usuario1.id
      conta1.save!

      saque = usuario1.saque(valor)

      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.tipo = :saque
      movimentacao1.save!

      expect(saque).to be true
    end

    it 'TRANSFERIR R$ 10,00' do
      usuario1 = Usuario.create! valid_attributes
      conta1 = Conta.new(conta_attributes)
      conta1.usuario_id = usuario1.id
      conta1.save!

      usuario2 = create(:usuario)
      conta2 = Conta.new(conta_attributes)
      conta2.usuario_id = usuario2.id
      conta2.save!

      valor = 10.0

      transferiu = usuario1.transferir(valor: valor, conta_id_transferencia: conta2&.id)

      # movimentacao transferencia usuario1
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.conta_transferencia_id = conta2.id
      movimentacao1.tipo = :transferencia
      movimentacao1.save!

      # movimentacao taxa_transferencia usuario1
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.tipo = :taxa_transferencia
      movimentacao1.save!

      # movimentacao transferencia_recebida usuario2
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = Conta.valor_taxa_transferencia(valor)
      movimentacao1.conta_id = conta2.id
      movimentacao1.conta_transferencia_id = conta1.id
      movimentacao1.tipo = :transferencia_recebida
      movimentacao1.save!

      expect(transferiu).to be true
    end

    it 'solicitar EXTRATO' do
      valor = 100.0
      usuario1 = Usuario.create! valid_attributes
      conta1 = Conta.new(conta_attributes)
      conta1.usuario_id = usuario1.id
      conta1.save!

      usuario1.depositar(valor)
      movimentacao1 = Movimentacao.new(movimentacao_attributes)
      movimentacao1.valor = valor
      movimentacao1.conta_id = conta1.id
      movimentacao1.tipo = :deposito
      movimentacao1.save!

      extrato = usuario1.conta.movimentacoes
                        .by_periodo(Date.today, Date.today)
                        .group_by { |m| m.created_at&.to_date }

      expect(extrato.present?).to be true
    end
  end
end
