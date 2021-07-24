namespace :crawlers do
  task scrape_culture_articles: :environment do
    new_articles = Crawlers::Culture.call

    print_report(new_articles)
    print_dismissal
  end

  task scrape_social_development_articles: :environment do
    new_articles = Crawlers::SocialDevelopment.call

    print_report(new_articles)
    print_dismissal
  end

  task scrape_articles: :environment do
    new_articles = Crawlers::Culture.call
    new_articles += Crawlers::SocialDevelopment.call

    print_group_report(new_articles)
    print_dismissal
  end

  def print_report new_articles
    puts "New saved articles: #{new_articles.count}\n"
  end

  def print_group_report new_articles
    Article.sources
           .keys
           .each do |source|
      saved_articles_amount = new_articles.count{ |article| article.source == source }
      source_name = source.to_s.gsub(/_/, ' ')
      puts "New #{source_name} saved articles: #{saved_articles_amount}\n"
    end
  end

  def print_dismissal
    puts "\nNo more new articles to scrape."
    puts 'Stopping crawler execution.'
    puts 'Byebye!'
  end
end
