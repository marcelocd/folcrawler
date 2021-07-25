class Article < ApplicationRecord
  include Hashid::Rails

  SOURCE_OPTIONS = %i[culture social_development]

  enum source: SOURCE_OPTIONS

  validates_presence_of :source,
                        :title,
                        :url,
                        :collected_at

  has_many :article_tags
  has_many :tags, through: :article_tags

  def self.most_recent_article source
    self.where(source: source.to_sym)
        .order(:created_at)
        .last
  end
end
