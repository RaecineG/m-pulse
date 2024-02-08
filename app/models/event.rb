class Event < ApplicationRecord
  belongs_to :user
  has_many :checkins
  has_many :comments
  has_many :reviews

  validates :name, presence: true
  # validates :address, presence: true
  # validates :description, presence: true
  # validates :start_at, presence: true
  # validates :end_at, presence: true
  # validates :category, presence: true
end
