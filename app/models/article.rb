class Article < ApplicationRecord
  validates_presence_of :source,
                        :title,
                        :url,
                        :collected_at

  scope :published_last, -> { where(published_at: self.maximum('published_at')) }
end
