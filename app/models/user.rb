class User < ApplicationRecord
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :reviews
  has_many :checkins
  has_many :events, dependent: :destroy
  has_many :events_as_attendee, through: :checkins, source: :event, dependent: :destroy
  has_many :badges, through: :user_badges
  has_one_attached :photo

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  acts_as_favoritable
  acts_as_favoritor

  # def followees
  #   favorited_by_type('User')
  # end

  # def current_attending_event
  #   events_as_attendee.last
  # end

  # validates :gender, presence: true
  # validates :date_of_birth, presence: true
end
