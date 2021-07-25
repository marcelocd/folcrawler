class Tag < ApplicationRecord
  validates :name, presence: true,
                   length: { maximum: 20 }

  has_many :article_tags
  has_many :articles, through: :article_tags
end
