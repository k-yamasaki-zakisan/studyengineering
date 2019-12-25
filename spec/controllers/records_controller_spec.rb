require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
	describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it '#index：遷移できる' do
        get :index
        expect(response).to have_http_status(200)
      end

      it '#edit：遷移できる' do
        record = FactoryBot.create(:record, user_id: @user.id)
        get :edit, params: { id: record.id }
        expect(response).to have_http_status(200)
      end

      it '#create：学習記録を投稿できる' do
        record_params = FactoryBot.attributes_for(:record)
        post :create, params: { record: record_params, user_id: @user.id }, xhr: true
        expect(response).to have_http_status(200)
        expect(flash[:add_record]).to eq "本日の進捗を追加しました"
      end

      it '#update：学習記録を投稿できる' do
        record = FactoryBot.create(:record, user_id: @user.id)
        patch :update, params: { record: FactoryBot.attributes_for(:record), id: record.id }
        expect(response).to redirect_to(records_path)
        expect(flash[:success_record_update]).to eq "進捗内容を更新しました"
      end
    end
  end

  describe '異常系' do
    context "ユーザーログインしていないとき" do
      before do
        @user = FactoryBot.create(:user)
        @record = FactoryBot.create(:record, user_id: @user.id)
      end

      it "#index：遷移できない" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#edit：遷移できない' do
        get :edit, params: { id: @record.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "#create：学習記録を投稿できない" do
        record_params = FactoryBot.attributes_for(:record)
        post :create, params: { record: record_params }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#update：学習記録を編集できない' do
        patch :update, params: { record: FactoryBot.attributes_for(:record), id: @record.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ユーザーログイン時に他のユーザーの投稿を操作しようとする" do
      before do
        @user = FactoryBot.create(:user)
        @record = FactoryBot.create(:record, user_id: @user.id)
        @new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        @new_user.save
        sign_in @new_user
      end

      it "#edit：遷移できない" do
        get :edit, params: { id: @record.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end

      # it '#update：学習記録を編集できない' do
      #   patch :update, params: { record: FactoryBot.attributes_for(:record), id: @record.id }
      #   expect(response).to have_http_status(302)
      # end

      # it '#destroy：学習記録を削除できない' do
      # end

    end
  end

end
