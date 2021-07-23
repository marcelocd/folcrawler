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
      articles = []
      initial_page = request_page(initial_page_url)
      byebug
      current_page = request_page(last_page_url(initial_page))
      current_page_number = last_page_number(current_page)
      loop do
        print_page_number(current_page_number)
        articles += scrape_articles_from_current_page(current_page)
        previous_page_url =
        break unless previous_page_url.present?

        current_page = request_page(previous_page_url)
        current_page_number -= 1
      end
      articles
    end

    def request_page url
      Nokogiri::HTML(ag.get(url).body)
    end

    def scrape_articles_from_current_page current_page
      articles = []
      current_page.css('article')
                  .to_a
                  .reverse
                  .each do |article_html_element|
        article_params = parse_article_params(article_html_element)
        new_article = Article.new(article_params)
        break if article_already_collected?(new_article)

        articles << new_article
        # print_article(articles.last)
      end
      articles
    end

    def initial_page_url
      "https:\/\/www\.gov\.br\/turismo\/pt-br/secretaria-especial-da-cultura\/assuntos\/noticias"
    end

    def last_page_url page
      pagination_links = page.css('.paginacao > li > a')
      return pagination_links.to_a.second_to_last['href'] if page.css('.proximo')

      pagination_links.last['href']
    end

    def last_page_number page
      pagination_links = page.css('.paginacao > li > a')
      return pagination_links.to_a
                             .second_to_last
                             .text
                             .to_i if page.css('.proximo')

      pagination_links.last
                      .text
                      .to_i
    end

    def parse_article_params article_html_element
      parser = CultureArticleParser.new(article: article_html_element)
      parser.parse_article_params
    end

    def article_already_collected? article
      @maximum_updated_at ||= Article.maximum('updated_at')
      return false unless @maximum_updated_at.present?
      return true unless article.modified_at &&
                         article.modified_at > @maximum_updated_at
      return true unless article.published_at > @maximum_updated_at
      false
    end

    def last_published_articles
      @last_published_articles ||= Article.published_last
    end

    def find_previous_page_url current_page
      next_button_element = current_page.css('.anterior')
      return unless next_button_element.any?

      next_button_element.last
                         .attributes['href']
                         .text
    end
  end
end
