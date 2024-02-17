class Event < ApplicationRecord
  belongs_to :user
  has_many :checkins, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :photo
  enum category: [:club, :sports, :meetup, :tech]

  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  # validates :address, presence: true
  # validates :description, presence: true
  # validates :start_at, presence: true
  # validates :end_at, presence: true
  # validates :category, presence: true
end
