class Feedback < ActiveRecord::Base

  # White list
  attr_accessible :account, :account_id, :body

  # Associations
  belongs_to :account

  # Validates
  validates :body, presence: true, length: { within: 1..1000 }

  # Scopes
  scope :created_desc, order("`created_at` DESC")

end