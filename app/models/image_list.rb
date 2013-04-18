class ImageList < ActiveRecord::Base

  # White list
  attr_accessible :name, :order

  # Associations
  has_many :images, :as => :imageable, :dependent => :destroy

  belongs_to :recommend_detailed

  validate :order_increment

  validates :name, length: { within: 1..20 }, presence: true
  validates :order, uniqueness: { scope: [:recommend_detailed_id, :order] },
                    numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }

  # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("`created_at` DESC")

  private

  def order_increment
    if self.new_record? && self.order == 0 && !self.recommend_detailed_id.nil?
      self.order = ImageList.where( recommend_detailed_id: self.recommend_detailed_id ).maximum(:order).to_i + 1
    elsif self.recommend_detailed_id.nil?      
      self.order = 1
    end
  end
end