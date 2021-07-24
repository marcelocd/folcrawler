module Crawlers
  class SocialDevelopment < ApplicationService
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
      current_page = get_initial_page
      loop do
        current_page_number = get_current_page_number(current_page)
        print_page_number(current_page_number)

        articles += scrape_articles_from_current_page(current_page)
        break if an_old_article_has_been_found?

        next_page_url = find_next_page_url(current_page)
        break unless next_page_url.present?

        current_page = request_page(next_page_url)
      end
      articles
    end

    def get_initial_page
      request_page(initial_page_url)
    end

    def request_page url
      Nokogiri::HTML(ag.get(url).body)
    end

    def scrape_articles_from_current_page current_page
      articles = []
      articles_list = current_page.css('article').to_a
      articles_list.each do |article_html_element|
        article_params = parse_article_params(article_html_element)
        new_article = Article.new(article_params)
        if article_already_collected?(new_article)
          @an_old_article_has_been_found = true
          break
        end

        new_article.save!
        articles << new_article
        print_article(articles.last)
      end
      articles
    end

    def an_old_article_has_been_found?
      @an_old_article_has_been_found
    end

    def initial_page_url
      "https:\/\/www\.gov\.br\/cidadania\/pt-br\/noticias-e-conteudos\/"\
      "desenvolvimento-social\/noticias-desenvolvimento-social"
    end

    def get_current_page_number current_page
      current_page.css('.paginacao > li > span')
                  .text
                  .gsub(/\D/, '')
    end

    def parse_article_params article_html_element
      parser = SocialDevelopmentArticleParser.new(article: article_html_element)
      parser.parse_article_params
    end

    def article_already_collected? article
      @most_recent_article ||= Article.most_recent_article('social_development')
      return false unless @most_recent_article.present?
      return true if article.title == @most_recent_article.title &&
                     article.published_at == @most_recent_article.published_at
      false
    end

    def find_next_page_url page
      next_button_element = page.css('.proximo')
      return unless next_button_element.any?

      next_button_element.last
                         .attributes['href']
                         .text
    end
  end
end
