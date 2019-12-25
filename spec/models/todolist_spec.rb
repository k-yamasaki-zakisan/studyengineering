require 'rails_helper'

RSpec.describe Todolist, type: :model do
  describe '正常系の機能' do
    context '登録する' do
      it '正しく登録できること' do

      	user = FactoryBot.build(:user)
      	expect(user).to be_valid
        user.save

        todolist = FactoryBot.build(:todolist, user_id: user.id)
      	expect(todolist).to be_valid
        todolist.save

        answered_todolist = Todolist.find_by(user_id: user.id);
        expect(answered_todolist.user_id).to eq(user.id)
        expect(answered_todolist.body).to eq('テストコードを10個書く')
        expect(answered_todolist.status).to eq("challenge")
      end
    end
  end

  describe '入力項目の有無' do
    context 'TODOモデル単体バリデーション 関連' do
    	user = FactoryBot.build(:user)

      it 'bodyがない' do
      	expect(user).to be_valid
        user.save
        list = Todolist.new(
          user_id: 1,
          deadline: 'Wed, 25 Dec 2019',
          status: 0,
          )
        expect(list).not_to be_valid
        expect(list.errors[:body]).to include(I18n.t('errors.messages.blank'))
      end

      it 'deadlineがない' do
        expect(user).to be_valid
        user.save
        list = Todolist.new(
          user_id: 1,
          body: 'テストコードを10個書く',
          status: 0,
          )
        expect(list).not_to be_valid
        expect(list.errors[:deadline]).to include(I18n.t('errors.messages.blank'))
      end

      it 'deadlineがない' do
        expect(user).to be_valid
        user.save
        list = Todolist.new(
          deadline: 'Wed, 25 Dec 2019',
          body: 'テストコードを10個書く',
          status: 0,
          )
        expect(list).not_to be_valid
        expect(list.errors[:user_id]).to include(I18n.t('errors.messages.blank'))
      end
    end

    context 'ユーザーなし' do
      it 'ユーザーの情報がDBにないと登録できない' do
      	todolist = FactoryBot.build(:todolist)
      	expect(todolist).not_to be_valid
      end
    end
  end
end
