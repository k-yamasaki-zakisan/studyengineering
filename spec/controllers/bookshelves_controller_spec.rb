require 'rails_helper'

RSpec.describe BookshelvesController, type: :controller do
  describe '正常系' do
    context 'ユーザーログインしてるとき' do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        sign_in @user
      end

      it '#create：本棚に本の取得できる' do
        bookshelf = Bookshelf.create
        params = '9784295005902'
        book = Book.new(book_code: params)
        bookshelf.user_id = @user.id
	      bookshelf.book_id = book.id
	      bookshelf.save
	      expect(response).to have_http_status(200)
      end

      it '#update：本のステータス更新できる' do
        bookshelf = FactoryBot.create(:bookshelf, user_id: @user.id, book_id: @book.id)
        patch :update, params: { bookshelf: FactoryBot.attributes_for(:bookshelf), id: bookshelf.id, status: '読了' }
        expect(response).to redirect_to(user_path(@user.id))
      end

      it '#destroy：本棚から本の削除できる' do
        bookshelf = FactoryBot.create(:bookshelf, user_id: @user.id, book_id: @book.id)
        delete :destroy, params: {id: bookshelf.id}
        expect(response).to redirect_to(user_path(@user.id))
      end
    end
  end

  describe '異常系' do
    context 'ユーザーログインしていないとき' do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        @bookshelf = FactoryBot.create(:bookshelf, user_id: @user.id, book_id: @book.id)
      end

      # it '#create：本棚に本の取得できない' do
      #   bookshelf = Bookshelf.create
      #   params = '9784295005902'
      #   book = Book.new(book_code: params)
      #   bookshelf.book_id = book.id
      #   bookshelf.save
      #   expect(response).to redirect_to(new_user_session_path)
      # end

      it '#update：本のステータス更新できない' do
        bookshelf_update_params = FactoryBot.attributes_for(:bookshelf)
        post :create, params: { bookshelf: bookshelf_update_params }
        expect(response).to redirect_to(new_user_session_path)
      end

      it '#destroy：本棚から本の削除できない' do
        delete :destroy, params: { id: @bookshelf.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ユーザーログイン時に他のユーザーの投稿を操作しようとする" do
      before do
        @user = FactoryBot.create(:user)
        @book = FactoryBot.create(:book)
        @bookshelf = FactoryBot.create(:bookshelf, user_id: @user.id, book_id: @book.id)
        @new_user = User.new(
          name: '田中',
          email: 'tett@test.com',
          password: '111111',
        )
        @new_user.save
        sign_in @new_user
      end

      # it '#update：本のステータス更新できない' do
      # end

      # it '#destroy：本棚から本の削除できない' do
      # end

    end
  end

end
