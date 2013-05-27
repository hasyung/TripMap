class LijiangMailbox < ActiveRecord::Base

  # White list
  attr_accessible :device_id, :service_score, :env_score, :category, :title, :content, :who, :contact

  # Validates
  validates :device_id, :service_score, :env_score, :category, :presence => true

  # Scopes
  scope :created_desc,  order("created_at DESC")

end