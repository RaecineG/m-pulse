class Event < ApplicationRecord
  belongs_to :user
  has_many :checkins, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  # validates :address, presence: true
  # validates :description, presence: true
  # validates :start_at, presence: true
  # validates :end_at, presence: true
  # validates :category, presence: true
end
