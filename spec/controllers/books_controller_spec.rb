require 'rails_helper'

#RSpec.describe BooksController, type: :controller do
  #describe '正常系' do
  #  context 'ページに遷移' do
      #it '#search：遷移後にキーワードで検索　→　再びsearch遷移' do
      #  get :search
      #  expect(response).to have_http_status(200)
      #  booktitle_params = 'Ruby'
      #  get :search
      #  expect(response).to have_http_status(200)
      #end

      # it '#detail：遷移' do
      # 	book_code = '9784295005902'
      #   get :detail, params: {book_code: book_code}
      #   expect(response).to have_http_status(200)
      # end

      #it '#show：遷移' do
      #	book = FactoryBot.create(:book)
      #  get :show, params: {id: book.id}
      #  expect(response).to have_http_status(200)
      #end
    #end
  #end

  #describe '異常系' do
  #  context "ページ遷移できない" do
  #    it "#search：遷移後に短いキーワードで検索　→　検索できない" do
  #      get :search
  #      expect(response).to have_http_status(200)
  #      booktitle_params = 'c'
  #      get :search
  #      expect(response).to have_http_status(200)
  #      # expect(flash[:danger]).to eq "Error: キーワードが短すぎます"
  #    end
  #  end
  #end

#end
