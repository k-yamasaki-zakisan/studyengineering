require 'rails_helper'

RSpec.describe BookshelvesController, type: :controller do
  describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        login_user
      end

      it '#create：本棚に本の取得' do
        bookshelf = Bookshelf.create
        params = '9784295005902'
        book = Book.new(book_code: params)
	    bookshelf.book_id = book.id
	    bookshelf.save
	    expect(response).to have_http_status(200)
      end

      # it '#update：本のステータス更新' do
      #   params = '9784295005902'
      #   book = Book.new(book_code: params)
      #   bookshelf = FactoryBot.build(:bookshelf)
      #   status = 2
      #   patch :update, params: {id: bookshelf.id, status: status}
      #   expect(response).to have_http_status(200)
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

      # it '#update：本のステータス更新' do
      #   book = FactoryBot.create(:book)
      #   bookshelf = FactoryBot.create(:bookshelf,  book_id: book.id)
      #   status = 2
      #   patch :update, bookshelf_update_params: {status: status}
      # end

      # it '#destroy：本棚から本の削除' do
      #   book = FactoryBot.create(:book)
      #   bookshelf = FactoryBot.create(:bookshelf,  book_id: book.id)
      #   delete :destroy, params: {id: bookshelf.id}
      # end
    end
  end

end
