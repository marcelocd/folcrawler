class CultureArticleParser
  def parse_article_params
    {
      source: 'culture',
      title: title,
      url: url,
      body: body,
      published_at: datetime,
      collected_at: DateTime.now
    }
  end

  private

  attr_reader :article, :ag

  def initialize args
    log ''
    @article = args[:article]
    @ag = Mechanize.new
  end

  def title
    log 'title'
    article.css('header > span.summary > a')
           .inner_text
  end

  def url
    log 'url'
    article.css('header > span.summary > a')
           .first
           .attributes['href']
           .text
  end

  def body
    log 'body'
    article_page.css('#parent-fieldname-text')
                .inner_text
                .strip
  end

  def article_page
    log 'article page'
    @article_page ||= Nokogiri::HTML(ag.get(url).body)
  end

  def datetime
    log 'DateTime'
    DateTime.new(year, month, day, hour, minute, 0)
  end

  def year
    log 'year'
    @year ||= date_string.match(/\d{4}$/)[0]
                         .to_i
  end

  def month
    log 'mont'
    @month = date_string.match(/\/(\d{1,2})\//)[1]
                        .to_i
  end

  def day
    log 'day'
    @day ||= date_string.match(/^\d{1,2}/)[0]
                        .to_i
  end

  def hour
    log 'hour'
    @hour ||= time_string.match(/^\d{1,2}/)[0]
                         .to_i
  end

  def minute
    log 'minute'
    @minute ||= time_string.match(/\d{1,2}$/)[0]
                           .to_i
  end

  def date_string
    byebug if article_page.css('.documentPublished').nil?
    @date_string ||= article_page.css('.documentPublished')
                                 .text
                                 .match(/(\d{1,2}\/){2}\d{4}/)[0]
  end

  def time_string
    log 'timestring'
    @time_string ||= article_page.css('.documentPublished')
                                 .text
                                 .match(/\d{1,2}h\d{1,2}/)[0]
  end

  def log message
    puts '-' * 99
    puts message
    puts '-' * 99
  end
end
