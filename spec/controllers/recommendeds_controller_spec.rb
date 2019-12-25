require 'rails_helper'

RSpec.describe RecommendedsController, type: :controller do
  describe '正常系' do
  	context 'ユーザーログインしてるとき' do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        sign_in @user
      end

	    it '#create：本をお勧めできる' do
        post :create, params: { user_id: @user.id, book_id: @book.id }, xhr: true
        expect(response).to have_http_status(200)
      end

      it '#destroy：本のお勧めの解除できる' do
        recommended = FactoryBot.create(:recommended, user_id: @user.id, book_id: @book.id)
        delete :destroy, params: {id: recommended.id}, xhr: true
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '異常系' do
    context 'ユーザーログインしていないとき' do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        @recommended = FactoryBot.create(:recommended, user_id: @user.id, book_id: @book.id)
      end

      it '#create：本棚に本の取得できない' do
        post :create, params: {user_id: @user.id, book_id: @book.id}
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#destroy：本棚から本の削除できない' do
        delete :destroy, params: { id: @recommended.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ユーザーログイン時に他のユーザーの投稿を操作しようとする' do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        @recommended = FactoryBot.create(:recommended, user_id: @user.id, book_id: @book.id)
        @new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        @new_user.save
        sign_in @new_user
      end

      # it '#create：本棚に本の取得できない' do
      # end

      # it '#destroy：本棚から本の削除できない' do
      # end
    end
  end

end
