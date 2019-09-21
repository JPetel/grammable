class Gram < ApplicationRecord
  

  mount_uploader :photo, PhotoUploader


  validates :message, presence: true
  validates :photo, presence: true


  belongs_to :user
  has_many :comments
  
end
