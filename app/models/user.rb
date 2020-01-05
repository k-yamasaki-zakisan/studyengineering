class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookshelves, dependent: :destroy
  has_many :books,  { through: :bookshelves }
  has_many :records, dependent: :destroy
  has_many :recommendeds, dependent: :destroy
  has_many :todolists, dependent: :destroy
  has_many :snsCredentials, dependent: :destroy

  validates :name, :email, presence: true

  def havebook(book)
    self.books.find_by(book_code: book.book_code)
  end

  def already_recommended?(book)
    self.recommendeds.exists?(book_id: book.id)
  end

  def ckeck_date(todolist)
    limit_time = self.todolists.find_by(id: todolist.id)
    (limit_time.deadline - Date.today).to_i
  end

  devise :omniauthable,omniauth_providers: [:google_oauth2, :twitter]

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      else
        user = User.create(
          name: auth.info.email,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
          )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      end
    end
    return user
  end

end
