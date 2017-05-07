class Job < ApplicationRecord
  validates :title, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  mount_uploader :image, ImageUploader
  has_many :resumes

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end



  scope :recent, -> {order('created_at DESC')}
  scope :published, -> {where(is_hidden: false)}

  has_many :resumes
  belongs_to :user
  has_many :collections, dependent: :destroy
  has_many :members, through: :collections, source: :user
end
