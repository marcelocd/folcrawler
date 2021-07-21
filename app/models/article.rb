class Article < ApplicationRecord
  validates_presence_of :source,
                        :title,
                        :url,
                        :published_at,
                        :collected_at,
                        :body
end
