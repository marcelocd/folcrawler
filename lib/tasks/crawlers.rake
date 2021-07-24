namespace :crawlers do
  task scrape_culture_articles: :environment do
    new_articles = Crawlers::Culture.call
    new_articles.each(&:save) if new_articles.any?

    print_report(new_articles)
    print_dismissal
  end

  def print_report new_articles
    puts "New saved articles: #{new_articles.count}\n"
  end

  def print_dismissal
    puts 'No more new articles to scrape.'
    puts 'Stopping crawler execution.'
    puts 'Byebye!'
  end
end
