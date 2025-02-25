class Location < ApplicationRecord
  validates :street, :city, :state, :country, presence: true
end
