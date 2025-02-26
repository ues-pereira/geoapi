module Repositories
  class ActiveRecord < BaseRepository
    class << self
      def find_by(klass, attrs)
        klass.find_by(**attrs)
      end

      def save!(object)
        object.save!
      end
    end
  end
end
