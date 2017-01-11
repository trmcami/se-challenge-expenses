require 'rails_helper'

RSpec.describe ExpensesController do
  describe 'GET new' do
    it 'should get new' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'should redirect to index when import is successful' do
      expenses_file = fixture_file_upload('expenses_example.csv')
      post :create, params: { expenses_file: expenses_file }
      expect(response).to redirect_to(expenses_path)
    end

    it 'should redirect to new when import is not successful' do
      expenses_file = fixture_file_upload('expenses_example_wrong.csv')
      post :create, params: { expenses_file: expenses_file }
      expect(response).to redirect_to(root_path)
    end
  end
end
