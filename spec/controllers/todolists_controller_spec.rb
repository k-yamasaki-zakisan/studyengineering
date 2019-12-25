require 'rails_helper'

RSpec.describe TodolistsController, type: :controller do
	describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        login_user
      end

      it '#index：遷移してtodoリストの投稿' do
        get :index
        expect(response).to have_http_status(200)
        todolist_params = FactoryBot.attributes_for(:todolist)
        post :create, params: { todolist: todolist_params }, xhr: true
      end

      # it '一覧ページに遷移してtodoリストの達成報告' do
      #   get :index
      #   expect(response).to have_http_status(200)
      #   todolist = FactoryBot.create(:todolist)
      #   patch :congratulations, params: { id: todolist.id }
      #   expect(response).to redirect_to(todolists_path)
      #   expect(flash[:success_update]).to eq "達成おめでとうございます!!"
      # end

      #recordのIDがなくて遷移できない
      # it '編集ページに遷移して投稿を編集' do
      #   todolist = FactoryBot.create(:todolist)
      #   todolist.save
      #   get :edit, params: {id: todolist.id}
      #   expect(response).to have_http_status(200)
      #   patch :update, params: {id: todolist.id, record: attributes_for(:todolist)}
      #   expect(response).to redirect_to todolists_path
      #   expect(flash[:success_todolist_update]).to eq "進捗内容を更新しました"
      # end
    end
  end

  describe '異常系' do
    context "ユーザーログインしていないとき" do

      it "#index：遷移できない" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "#index：投稿できない" do
        todolist_params = FactoryBot.attributes_for(:todolist)
        post :create, params: { record: todolist_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
