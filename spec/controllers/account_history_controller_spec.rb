require "rails_helper"

RSpec.describe AccountHistoryController, :type => :controller do
  describe 'GET #index' do
    context 'when the parameter view is chart' do
      it 'renders the chart view' do
        get :index, {:view => 'chart'}
        expect(response).to render_template(:chart)
      end
    end

    context 'when the parameter view is table' do
      it 'renders the index view' do
        get :index, {:view => 'table'}
        expect(response).to render_template(:index)
      end
    end

    context 'when the parameter view is absent' do
      it 'renders the index view' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
