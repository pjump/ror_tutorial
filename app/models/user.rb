class User < ActiveRecord::Base
  before_create :create_remember_token
  before_save { self.email.downcase! }
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :reverse_relationships,
    foreign_key: :followed_id,
    class_name: :Relationship,
    dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships#, source: :follower
  validates :password, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  def feed
    #microposts
    #Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end


  #Public class methods
  class << self
    def new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.hash(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end

  private
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
