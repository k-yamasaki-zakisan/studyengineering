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

      it '#edit：遷移できる' do
        get :edit, params: { id: @user.id }
        expect(response).to have_http_status(200)
      end

      it '#update：編集できる' do
        patch :update, params: { user: FactoryBot.attributes_for(:user), id: @user.id }
        expect(response).to redirect_to(user_path(@user.id))
        expect(flash[:user_update]).to eq "登録情報を更新しました"
      end

      it '#destroy：削除できる' do
        delete :destroy, params: { id: @user.id }
        expect {
          delete :destroy, params: {id: @user.id}
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(root_path)
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

      it '#edit：遷移できない' do
        get :edit, params: { id: @user.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#update：編集できない' do
        patch :update, params: { user: FactoryBot.attributes_for(:user), id: @user.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#destroy：削除ができない' do
        delete :destroy, params: { id: @user.id }
        expect {
          delete :destroy, params: { id: @user.id }
        }.to_not change(User, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ユーザーログインしていて他のユーザーページに行こうとしたとき' do
      before do
        @user = FactoryBot.create(:user)
        @new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        @new_user.save
        sign_in @new_user
      end

      it '#show：遷移できない' do
        get :show, params: { id: @user.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(user_path(@new_user.id))
      end

      it '#edit：遷移できない' do
        get :edit, params: { id: @user.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end

      it '#update：編集できない' do
        patch :update, params: { user: FactoryBot.attributes_for(:user), id: @user.id }
        expect(response).to redirect_to(user_path(@new_user.id))
      end

      it '#destroy：削除ができない' do
        delete :destroy, params: { id: @user.id }
        expect {
          delete :destroy, params: { id: @user.id }
        }.to_not change(User, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
