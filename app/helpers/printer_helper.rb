module PrinterHelper
  def print_page_number page_number
    puts '-' * 99
    puts "PAGE #{page_number}"
    puts '-' * 99
  end

  def print_article article
    puts '-' * 99
    puts "source: #{article[:source]}"
    puts "title: #{article[:title]}"
    puts "url: #{article[:url]}"
    puts "body: #{article[:body]}"
    puts "published_at: #{article[:published_at]}"
    puts "modified_at: #{article[:modified_at]}"
    puts "collected_at: #{article[:collected_at]}"
    puts '-' * 99
  end

  def log message
    puts '-' * 99
    puts message
    puts '-' * 99
  end
end
