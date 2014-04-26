class Relationship < ActiveRecord::Base
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"
  validates :followed, presence: true
  validates :follower, presence: true
end
