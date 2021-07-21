class CultureArticleParser
  def parse_article_params
    {
      source: 'Culture',
      title: title,
      url: url,
      body: body,
      published_at: datetime,
      collected_at: DateTime.now
    }
  end

  private

  attr_reader :article

  def initialize args
    @article = args[:article]
  end

  def title
    article.css('header > span.summary > a')
           .inner_text
  end

  def url
    article.css('header > span.summary > a')
           .first
           .attributes['href']
           .text
  end

  def body
    article.css('p')
           .try(:text)
  end

  def datetime
    DateTime.new(year, month, day, hour, minute, 0)
  end

  def year
    @year ||= date_string.match(/\d{4}$/)[0]
                         .to_i
  end

  def month
    @month = date_string.match(/\/(\d{1,2})\//)[1]
                        .to_i
  end

  def day
    @day ||= date_string.match(/^\d{1,2}/)[0]
                        .to_i
  end

  def hour
    @hour ||= time_string.match(/^\d{1,2}/)[0]
                         .to_i
  end

  def minute
    @minute ||= time_string.match(/\d{1,2}$/)[0]
                           .to_i
  end

  def date_string
    @date_string ||= article.css('header > span.documentByLine')
                            .inner_text
                            .match(/(\d{1,2}\/){2}\d{4}/)[0]
  end

  def time_string
    @time_string ||= article.css('header > span.documentByLine')
                            .inner_text
                            .match(/\d{1,2}h\d{1,2}/)[0]
  end
end
