class Gram < ApplicationRecord
  

  mount_uploader :photo, PhotoUploader


  validates :message, presence: true
  


  belongs_to :user
end
