class Facebookpost < ActiveRecord::Base
  attr_accessible :post, :post_id
  belongs_to :user
  
  validates :post, presence: true
  validates :user_id, presence: true
  
  default_scope order: 'facebookposts.created_at DESC'
end
