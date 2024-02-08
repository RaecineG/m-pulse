class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments
  has_many :reviews
  has_many :checkins
  has_many :events_as_attendee, through: :checkins, source: :event
  has_many :badges, through: :user_badges

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :gender, presence: true
  validates :date_of_birth, presence: true
end
