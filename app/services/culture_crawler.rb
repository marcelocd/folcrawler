class CultureCrawler < ApplicationService
  def call
    get_articles
  rescue StandardError => error
    error.message
  end

  private

  attr_accessor :ag

  def initialize
    @ag = Mechanize.new()
  end

  def get_articles
    articles = []
    current_page = initial_page
    page_number = 1
    loop do
      print_page(page_number)
      current_page.css('article')
                  .each do |article|
        new_article = Article.new(article_params(article))
        byebug
        return articles if article_already_collected?(new_article)

        articles << new_article
        print_article(articles.last) ; nil
      end

      next_page_url = find_next_page_url(current_page)
      return articles unless next_page_url.present?

      current_page = next_page(next_page_url)
      page_number += 1
    end
    articles
  end

  def initial_page
    @initial_page ||= Nokogiri::HTML(ag.get(initial_url)
                                       .body)
  end

  def next_page next_page_url
    Nokogiri::HTML(ag.get(next_page_url)
                      .body)
  end

  def initial_url
    "https:\/\/www\.gov\.br\/turismo\/pt-br/secretaria-especial-da-cultura\/assuntos\/noticias"
  end

  def article_params article
    parser = CultureArticleParser.new(article: article)
    parser.parse_article_params
  end

  def article_already_collected? article
    article.title
           .in?(last_published_articles.map(&:title)) &&
    article.datetime == last_published_articles.sample
                                               .try(:datetime)
  end

  def last_published_articles
    @last_published_articles ||= Article.published_last
  end

  def find_next_page_url current_page
    next_button_element = current_page.css('.proximo')
    return unless next_button_element.any?

    next_button_element.last
                       .attributes['href']
                       .text
  end

  def print_page page_number
    puts '-' * 99
    puts "PAGE #{page_number}"
    puts '-' * 99
  end

  def print_article article
    puts '-' * 99
    # puts "source: #{t(article[:source])}"
    puts "source: #{article[:source]}"
    puts "title: #{article[:title]}"
    puts "url: #{article[:url]}"
    puts "body: #{article[:body]}"
    puts "published_at: #{article[:published_at]}"
    puts "collected_at: #{article[:collected_at]}"
    puts '-' * 99
  end
end
