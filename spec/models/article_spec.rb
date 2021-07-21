require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { create(:article) }

  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:published_at) }
  it { should validate_presence_of(:collected_at) }
  it { should validate_presence_of(:body) }

  it 'has valid factory' do
    expect(article).to be_valid
  end
end
