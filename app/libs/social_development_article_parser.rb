class SocialDevelopmentArticleParser
  def parse_article_params
    {
      source: 'social_development',
      title: title,
      url: url,
      body: body,
      published_at: build_datetime('publication'),
      modified_at: build_datetime('modification'),
      collected_at: DateTime.now
    }
  end

  private

  attr_reader :article, :ag

  def initialize args
    @article = args[:article]
    @ag = Mechanize.new
  end

  def title
    article.css('.tileHeadline').text.strip
  end

  def subtitle
    article.css('.tileBody').text.strip
  end

  def url
    article.css('.summary').first['href']
  end

  def body
    article_page.css('#parent-fieldname-text')
                .text
                .strip
  end

  def article_page
    @article_page ||= Nokogiri::HTML(ag.get(url).body)
  end

  def build_datetime option
    date_string = parse_date_string(option)
    return unless date_string.present?

    time_string = parse_time_string(option)
    DateTime.new(DateTimeParser.year(date_string),
                 DateTimeParser.month(date_string),
                 DateTimeParser.day(date_string),
                 DateTimeParser.hour(time_string),
                 DateTimeParser.minute(time_string),
                 0)
  end

  def parse_date_string option
    date_selector = {
      'publication': '.documentPublished',
      'modification': '.documentModified'
    }[option.to_sym]

    date_element = article_page.css(date_selector)
    return unless date_element.present?

    date_element.text.match(/(\d{1,2}\/){2}\d{4}/)[0]
  end

  def parse_time_string option
    time_selector = {
      'publication': '.documentPublished',
      'modification': '.documentModified'
    }[option.to_sym]

    time_element = article_page.css(time_selector)
    return unless time_element.present?

    time_element.text.match(/\d{1,2}h\d{1,2}/)[0]
  end
end
