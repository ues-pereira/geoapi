require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { described_class.new(street: 'Avenida Paulista', number: 7, city: 'São Paulo', state: 'São Paulo', country: 'Brazil') }

  describe 'validations' do
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
  end
end
