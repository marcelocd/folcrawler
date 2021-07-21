namespace :crawler do
  task save_new_articles: :environment do
    initial_articles_amount = Article.count

    articles = CultureCrawler.call
    articles.each(&:save) if articles.any?

    puts "Novos artigos salvos: #{Article.count - initial_articles_amount}"
  end

end
