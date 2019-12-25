require 'rails_helper'

RSpec.describe User, type: :model do
  describe '正常系の機能' do
    context '登録する' do
      it '正しく登録できること' do

      	user = FactoryBot.build(:user)
      	expect(user).to be_valid
        user.save

        answered_user = User.find_by(id: user.id);
        expect(answered_user.name).to eq('田中')
        expect(answered_user.email).to eq('t@test.com')
      end
    end
  end

  describe '入力項目の有無' do
    context '必須入力であること' do
      it 'お名前が必須であること' do
        new_user = User.new

        expect(new_user).not_to be_valid
        expect(new_user.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end

      it 'メールアドレスが必須であること' do
        new_user = User.new
        expect(new_user).not_to be_valid
        expect(new_user.errors[:email]).to include(I18n.t('errors.messages.blank'))
      end

      it 'メールアドレス同じだと登録できないこと' do
      	user = FactoryBot.build(:user)
        user.save
        new_user = User.new(
          name: '田中 太郎',
          email: 't@test.com',
          )
        expect(new_user).not_to be_valid
      end

      it '登録できないこと' do
        new_user = User.new
        expect(new_user.save).to be_falsey
      end
    end
  end
end
