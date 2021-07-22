namespace :crawlers do
  task search_new_culture_articles: :environment do
    new_articles = Crawlers::Culture.call
    new_articles.each(&:save) if new_articles.any?

    print_report(new_articles)
  end

  def print_report new_articles
    puts "New saved articles: #{new_articles.count}"
  end
end
