class Review < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :rating, inclusion: { in: [1, 2, 3, 4, 5], allow_nil: false }
end
