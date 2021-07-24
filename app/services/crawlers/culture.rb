module Crawlers
  class Culture < ApplicationService
    include PrinterHelper

    def call
      get_articles.reverse
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
      current_page = get_last_page
      loop do
        current_page_number = get_current_page_number(current_page)
        print_page_number(current_page_number)

        articles += scrape_articles_from_current_page(current_page)
        break if an_old_article_has_been_found?

        previous_page_url = find_previous_page_url(current_page)
        break unless previous_page_url.present?

        current_page = request_page(previous_page_url)
      end
      articles
    end

    def get_last_page
      initial_page = request_page(initial_page_url)
      request_page(last_page_url(initial_page))
    end

    def request_page url
      Nokogiri::HTML(ag.get(url).body)
    end

    def scrape_articles_from_current_page current_page
      articles = []
      reversed_articles_list = current_page.css('article')
                                           .to_a
                                           .reverse
      reversed_articles_list.each do |article_html_element|
        article_params = parse_article_params(article_html_element)
        new_article = Article.new(article_params)
        if article_already_collected?(new_article)
          @an_old_article_has_been_found = true
          break
        end

        articles << new_article
        print_article(articles.last)
      end
      articles
    end

    def an_old_article_has_been_found?
      @an_old_article_has_been_found
    end

    def initial_page_url
      "https:\/\/www\.gov\.br\/turismo\/pt-br/secretaria-especial-da-cultura\/assuntos\/noticias"
    end

    def last_page_url page
      pagination_links = page.css('.paginacao > li > a')
      return pagination_links.to_a.second_to_last['href'] if page.css('.proximo')

      pagination_links.last['href']
    end

    def get_current_page_number current_page
      current_page.css('.paginacao > li > span').text
    end

    def parse_article_params article_html_element
      parser = CultureArticleParser.new(article: article_html_element)
      parser.parse_article_params
    end

    def article_already_collected? article
      @most_recent_article ||= Article.most_recent_article('culture')
      return false unless @most_recent_article.present?
      return true if article.title == @most_recent_article.title &&
                     article.published_at == @most_recent_article.published_at
      false
    end

    def find_previous_page_url page
      previous_button_element = page.css('.anterior')
      return unless previous_button_element.any?

      previous_button_element.last
                             .attributes['href']
                             .text
    end
  end
end
