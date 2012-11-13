class User < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :facebookposts, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  private

    def create_remember_token
      Rails.logger.info("......create_remember_token CALLED.....................")
      self.remember_token = SecureRandom.urlsafe_base64
      Rails.logger.info(self.remember_token)
      self.remember_token 
    end

end
