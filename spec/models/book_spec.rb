require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '正常系の機能' do
    context '登録する' do
      it '正しく登録できること' do

      	book = FactoryBot.build(:book)
      	expect(book).to be_valid
        book.save

        answered_book = Book.find_by(id: book.id);
        expect(answered_book.title).to eq('スラスラ読めるRubyふりがなプログラミング')
        expect(answered_book.url).to eq('https://books.rakuten.co.jp/rb/15819130/')
        expect(answered_book.book_code).to eq('9784295005902')
        expect(answered_book.sales_date).to eq('2019年03月')
        expect(answered_book.price).to eq('2200')
        expect(answered_book.author).to eq('高橋征義/リブロワークス')
        expect(answered_book.caption).to eq('基本をしっかり。目指したのは「究極のやさしさ」。コードを読む力でレール（Ｒａｉｌｓ）を乗りこなそう！！登場するコードに「ふりがな」を。さらに「読み下し文」でフォロー。')
        expect(answered_book.review_average).to eq('1.0')
        expect(answered_book.review_count).to eq('4.1')
        expect(answered_book.small_image_url).to eq('https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5902/9784295005902.jpg?_ex=64x64')
        expect(answered_book.medium_image_url).to eq('https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5902/9784295005902.jpg')
        expect(answered_book.large_image_url).to eq('https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5902/9784295005902.jpg?_ex=200x200')
      end
    end
  end

   describe '入力項目の有無' do
    context '必須入力であること' do
      it 'お名前が必須であること' do
        book = Book.new

        expect(book).not_to be_valid
        expect(book.errors[:title]).to include(I18n.t('errors.messages.blank'))
      end

      it 'お名前が必須であること' do
        book = Book.new

        expect(book).not_to be_valid
        expect(book.errors[:url]).to include(I18n.t('errors.messages.blank'))
      end

      it 'お名前が必須であること' do
        book = Book.new

        expect(book).not_to be_valid
        expect(book.errors[:book_code]).to include(I18n.t('errors.messages.blank'))
      end

      it 'お名前が必須であること' do
        book = Book.new

        expect(book).not_to be_valid
        expect(book.errors[:medium_image_url]).to include(I18n.t('errors.messages.blank'))
      end

      it '登録できないこと' do
        book = Book.new
        expect(book.save).to be_falsey
      end
    end
  end
end
