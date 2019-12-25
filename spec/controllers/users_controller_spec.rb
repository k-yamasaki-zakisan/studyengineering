require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it '#show：遷移できる' do
        get :show, params: { id: @user.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '異常系' do
    context 'ユーザーログインしていないとき' do
      before do
        @user = FactoryBot.create(:user)
      end

      it '#show：遷移できない' do
        get :show, params: { id: @user.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ユーザーログインしていて他のユーザーページに行こうとしたとき' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it '#show：遷移できない' do
        new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        new_user.save

        get :show, params: { id: new_user.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(user_path(@user.id))
      end
    end
  end

end
