class Feedback < ActiveRecord::Base
  attr_accessible :account, :account_id, :body

  belongs_to :account

  validates :body, presence: true, length: { within: 1..1000 ,   message: I18n.t("errors.type.name") }

  scope :created_desc, order("`created_at` DESC")
end
