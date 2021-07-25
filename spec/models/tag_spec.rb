require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(20) }
  it { should have_many(:articles) }

  it 'has valid factory' do
    expect(tag).to be_valid
  end
end
