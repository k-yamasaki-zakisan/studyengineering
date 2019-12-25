FactoryBot.define do
  factory :todolist do

    user_id { 1 }
    body { 'テストコードを10個書く' }
    deadline { 'Wed, 25 Dec 2019' }
    status { 'challenge' }
  end
end
