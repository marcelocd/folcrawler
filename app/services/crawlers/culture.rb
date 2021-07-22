module Crawlers
  class Culture < ApplicationService
    include PrinterHelper

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
      current_page = request_page(initial_page_url)
      current_page_number = 1
      articles = []
      loop do
        print_page_number(current_page_number)
        articles += scrape_articles_from_current_page(current_page)
        next_page_url = find_next_page_url(current_page)
        break unless next_page_url.present?

        current_page = request_page(next_page_url)
        current_page_number += 1
      end
      articles
    end

    def request_page url
      Nokogiri::HTML(ag.get(url).body)
    end

    def scrape_articles_from_current_page current_page
      articles = []
      current_page.css('article')
                  .each do |article_html_element|
        article_params = parse_article_params(article_html_element)
        new_article = Article.new(article_params)
        break if article_already_collected?(new_article)

        articles << new_article
      end
      articles
    end

    def initial_page_url
      "https:\/\/www\.gov\.br\/turismo\/pt-br/secretaria-especial-da-cultura\/assuntos\/noticias"
    end

    def parse_article_params article_html_element
      parser = CultureArticleParser.new(article: article_html_element)
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
  end
end
