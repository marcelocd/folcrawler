class CrawlerWorker
  include Sidekiq::Worker

  def perform
    Crawlers::Culture.call
    Crawlers::SocialDevelopment.call
  end
end
