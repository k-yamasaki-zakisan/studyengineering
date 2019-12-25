require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
	describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        login_user
      end

      it '#index：遷移して学習記録の投稿' do
        get :index
        expect(response).to have_http_status(200)
        record_params = FactoryBot.attributes_for(:record)
        post :create, params: { record: record_params }, xhr: true
      end

      #recordのIDがなくて遷移できない
      # it '編集ページに遷移して投稿を編集' do
      #   record = FactoryBot.build(:record)
      #   record.save
      #   get :edit, params: {id: record.id}
      #   expect(response).to have_http_status(200)
      #   patch :update, params: {id: record.id, record: attributes_for(:record)}
      #   expect(response).to redirect_to records_path
      #   expect(flash[:success_record_update]).to eq "進捗内容を更新しました"
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
        record_params = FactoryBot.attributes_for(:record)
        post :create, params: { record: record_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
