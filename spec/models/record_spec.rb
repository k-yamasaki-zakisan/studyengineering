require 'rails_helper'

RSpec.describe Record, type: :model do
  describe '正常系の機能' do
    context '登録する' do
      it '正しく登録できること' do

      	user = FactoryBot.build(:user)
      	expect(user).to be_valid
        user.save

        record = FactoryBot.build(:record, user_id: user.id)
      	expect(record).to be_valid
        record.save

        answered_record = Record.find_by(user_id: user.id);
        expect(answered_record.user_id).to eq(user.id)
        expect(answered_record.title).to eq('Udmeyの動画視聴')
        expect(answered_record.body).to eq('JSを勉強する')
        expect(answered_record.studytime).to eq(11)
      end
    end
  end

  describe '入力項目の有無' do
    context 'recordモデル単体バリデーション 関連' do
    	user = FactoryBot.build(:user)

      it 'studytimeがない' do
      	expect(user).to be_valid
        user.save
        record = Record.new(
          user_id: 1,
          title: 'Udmeyの動画視聴',
          body: 'JSを勉強する',
          )
        expect(record).not_to be_valid
        expect(record.errors[:studytime]).to include(I18n.t('errors.messages.blank'))
      end

      it 'bodyがない' do
      	expect(user).to be_valid
        user.save
        record = Record.new(
          user_id: 1,
          title: 'Udmeyの動画視聴',
          studytime: 11,
          )
        expect(record).not_to be_valid
        expect(record.errors[:body]).to include(I18n.t('errors.messages.blank'))
      end

      it 'bodyがない' do
      	expect(user).to be_valid
        user.save
        record = Record.new(
          user_id: 1,
          studytime: 11,
          body: 'JSを勉強する',
          )
        expect(record).not_to be_valid
        expect(record.errors[:title]).to include(I18n.t('errors.messages.blank'))
      end
    end

    context 'ユーザーなし' do
      it 'ユーザーの情報がDBにないと登録できない' do
      	record = FactoryBot.build(:record)
      	expect(record).not_to be_valid
      end
    end
  end
end
