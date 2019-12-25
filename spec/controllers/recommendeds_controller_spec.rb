require 'rails_helper'

RSpec.describe RecommendedsController, type: :controller do
  describe '正常系' do
  	context 'ユーザーログインしてるとき' do
      before do
        login_user
      end

	  it '#create：本をお勧めする' do
          book = FactoryBot.build(:book)
          book.save
	      post :create, params: {book_id: book.id}, xhr: true
      end

      # it '#destroy：本のお勧めの解除する' do
      #     book = FactoryBot.build(:book)
      #     book.save
      #     recommended = FactoryBot.create(:recommended, book_id: book.id)
	     #  delete :destroy, params: {id: recommended.id}, xhr: true
      # end

      # it '#destroy：本棚から本の削除' do
      #   book = FactoryBot.create(:book)
      #   bookshelf = FactoryBot.create(:bookshelf,  book_id: book.id)
      #   delete :destroy, params: {id: bookshelf.id}
      #   expect(response).to have_http_status(200)
      # end
    end
  end

  describe '異常系' do
    context 'ユーザーログインしていないとき' do

     #  it '#create：本棚に本の取得できない' do
     #    bookshelf = Bookshelf.create
     #    params = '9784295005902'
     #    book = Book.new(book_code: params)
	    # bookshelf.book_id = book.id
	    # bookshelf.save
	    # expect(response).to have_http_status(200)
     #  end

      # it '#destroy：本棚から本の削除' do
      #   book = FactoryBot.create(:book)
      #   bookshelf = FactoryBot.create(:bookshelf,  book_id: book.id)
      #   delete :destroy, params: {id: bookshelf.id}
      # end
    end
  end

end
