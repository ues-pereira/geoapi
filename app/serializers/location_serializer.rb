class LocationSerializer < ActiveModel::Serializer
  attributes :street
  attributes :city
  attributes :number
  attributes :state
  attributes :country
  attributes :latitude
  attributes :longitude
end
