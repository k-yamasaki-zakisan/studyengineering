require 'rails_helper'

RSpec.describe TopsController, type: :controller do
  describe '正常系' do
    context 'ユーザーログインしてるとき' do

      it 'topページに遷移' do
        get :top
        expect(response).to have_http_status(200)
      end

      it 'privacyページに遷移' do
        get :privacy
        expect(response).to have_http_status(200)
      end
    end
  end

end
