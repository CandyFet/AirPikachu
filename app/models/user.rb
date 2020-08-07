class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

  validates :fullname, presence: true, length: { maximum: 50 }

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)
    if user
      return user
    else
      create_or_fullfill_user_by_oauth(auth)
    end
  end

  private

  def self.create_or_fullfill_user_by_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.fullname = auth.info.name
      user.image = auth.info.image
      user.uid = auth.uid
      user.provider = auth.provider

      user.skip_confirmation!
    end
  end
end
