# frozen_string_literal: true

RSpec.describe ApplicationController do
  before(:each) do
    controller.stub(:authenticate_request => true)
  end

  describe 'handling exceptions' do
    controller do
      def index
        raise Exception
      end
    end

    it 'handles general exceptions' do
      get :index
      expect(response.status).to eq(500)
      expect(response.body).to eq('{"error_message":"Internal error"}')
    end

    describe 'record not found' do
      controller do
        def index
          raise ActiveRecord::RecordNotFound
        end
      end

      it ' rescues from not found' do
        get :index
        expect(response.status).to eq(404)
        expect(response.body).to eq('{"error_message":"Not found"}')
      end
    end
  end
end
