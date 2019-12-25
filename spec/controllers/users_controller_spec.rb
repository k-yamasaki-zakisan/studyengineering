require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        login_user
      end

      # it 'showページに遷移' do
      #   get :show
      #   expect(response).to have_http_status(200)
      # end
    end
  end

end
