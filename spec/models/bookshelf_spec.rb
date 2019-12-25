require 'rails_helper'

RSpec.describe Bookshelf, type: :model do
  describe '正常系の機能' do
    context '登録する' do
      it '正しく登録できること' do

      	user = FactoryBot.build(:user)
      	expect(user).to be_valid
        user.save

        book = FactoryBot.build(:book)
      	expect(book).to be_valid
        book.save

        bookshelf = FactoryBot.build(:bookshelf, user_id: user.id, book_id: book.id)
      	expect(bookshelf).to be_valid
        bookshelf.save

        answered_bookshelf = Bookshelf.find_by(user_id: user.id);
        expect(answered_bookshelf.user_id).to eq(user.id)
        expect(answered_bookshelf.book_id).to eq(book.id)
      end
    end
  end

  describe '入力項目の有無' do
  	context 'recordモデル単体バリデーション 関連' do
    	user = FactoryBot.build(:user)
    	book = FactoryBot.build(:book)

      it 'user_idがない' do
      	expect(user).to be_valid
        user.save
        expect(book).to be_valid
        book.save

        bookshelf = Bookshelf.new(
          book_id: 1,
          )
        expect(bookshelf).not_to be_valid
        expect(bookshelf.errors[:user_id]).to include(I18n.t('errors.messages.blank'))
      end

      it 'book_idがない' do
      	expect(user).to be_valid
        user.save
        expect(book).to be_valid
        book.save
        bookshelf = Bookshelf.new(
          user_id: 1,
          )
        expect(bookshelf).not_to be_valid
        expect(bookshelf.errors[:book_id]).to include(I18n.t('errors.messages.blank'))
      end
    end

    context '親要素なし' do
      it '本の情報がDBにないと登録できない' do
      	book = FactoryBot.build(:book)
      	expect(book).to be_valid
        book.save

      	bookshelf = FactoryBot.build(:bookshelf)
      	expect(bookshelf).not_to be_valid
      end
      it 'ユーザーの情報がDBにないと登録できない' do
      	user = FactoryBot.build(:user)
      	expect(user).to be_valid
        user.save

      	bookshelf = FactoryBot.build(:bookshelf)
      	expect(bookshelf).not_to be_valid
      end
    end
  end
end
