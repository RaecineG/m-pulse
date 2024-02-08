class Badge < ApplicationRecord
  has_many :users, through: :user_badges
end
