require 'rails_helper'

RSpec.describe TodolistsController, type: :controller do
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
        todolist = FactoryBot.create(:todolist, user_id: @user.id)
        get :edit, params: {id: todolist.id}
        expect(response).to have_http_status(200)
      end

      it '#create：todoリストの投稿できる' do
        todolist_params = FactoryBot.attributes_for(:todolist)
        post :create, params: { todolist: todolist_params, user_id: @user.id }, xhr: true
        expect(response).to have_http_status(200)
        expect(flash[:add_todo]).to eq "リストに目標を追加しました"
      end

      it '#congratulationsのtodo達成報告できる' do
        todolist = FactoryBot.create(:todolist, user_id: @user.id)
        patch :update, params: { todolist: FactoryBot.attributes_for(:todolist), id: todolist.id, status: 'complete' }
        expect(response).to redirect_to(todolists_path)
      end

      it '#update：todoリストの編集できる' do
        todolist = FactoryBot.create(:todolist, user_id: @user.id)
        patch :update, params: { todolist: FactoryBot.attributes_for(:todolist), id: todolist.id }
        expect(response).to redirect_to(todolists_path)
        expect(flash[:success_todo_update]).to eq "Todoリストを更新しました"
      end

      it '#destroy：todoの削除できる' do
        todolist = FactoryBot.create(:todolist, user_id: @user.id)
        delete :destroy, params: { id: todolist.id }, xhr: true
        expect(response).to have_http_status(200)
        expect(flash[:destroy_todo]).to eq "リストを削除しました"
      end

      it '#destroy_all：todoの削除できる' do
        todolist = FactoryBot.create(:todolist, user_id: @user.id)
        delete :destroy_all
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '異常系' do
    context "ユーザーログインしていないとき" do
      before do
        @user = FactoryBot.create(:user)
        @todolist = FactoryBot.create(:todolist, user_id: @user.id)
      end

      it "#index：遷移できない" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "#edit：遷移できない" do
        get :edit, params: { id: @todolist.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "#create：投稿できない" do
        todolist_params = FactoryBot.attributes_for(:todolist)
        post :create, params: { todolist: todolist_params }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#congratulationsのtodo達成報告できない' do
        patch :update, params: { todolist: FactoryBot.attributes_for(:todolist), id: @todolist.id, status: 'complete' }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#update：todoリストの編集できない' do
        patch :update, params: { todolist: FactoryBot.attributes_for(:todolist), id: @todolist.id }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#destroy：todoの削除ができない' do
        delete :destroy, params: { id: @todolist.id }
        expect {
          delete :destroy, params: { id: @todolist.id }
        }.to_not change(Todolist, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ユーザーログイン時に他のユーザーの投稿を操作しようとする" do
      before do
        @user = FactoryBot.create(:user)
        @todolist = FactoryBot.create(:todolist, user_id: @user.id)
        @new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        @new_user.save
        sign_in @new_user
      end

      it "#edit：遷移できない" do
        get :edit, params: { id: @todolist.id }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end

      # it '#congratulationsのtodo達成報告できない' do
      # end

      # it '#update：todoリストの編集できない' do
      # end

      # it '#destroy：todoの削除できない' do
      # end

    end
  end

end
