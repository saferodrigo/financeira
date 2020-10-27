require 'rails_helper'

RSpec.describe ContasController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/contas').to route_to('contas#index')
    end

    it 'routes to #new' do
      expect(get: '/contas/new').to route_to('contas#new')
    end

    it 'routes to #show' do
      expect(get: '/contas/1').to route_to('contas#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/contas/1/edit').to route_to('contas#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/contas').to route_to('contas#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/contas/1').to route_to('contas#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/contas/1').to route_to('contas#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/contas/1').to route_to('contas#destroy', id: '1')
    end
  end
end
