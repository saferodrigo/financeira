# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sessions/new.html.erb', type: :view do
  before(:each) do
    assign(:usuario, build(:usuario))
  end

  it 'renders login form' do
    render

    assert_select 'form[action=?][method=?]', login_path, 'post' do
      assert_select 'input[name=?]', 'session[cpf]'

      assert_select 'input[name=?]', 'session[password]'
    end
  end
end
