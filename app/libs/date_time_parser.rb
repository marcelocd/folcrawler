class DateTimeParser
  def self.year date_string
    date_string.match(/\d{4}$/)[0].to_i
  end

  def self.month date_string
    date_string.match(/\/(\d{1,2})\//)[1].to_i
  end

  def self.day date_string
    date_string.match(/^\d{1,2}/)[0].to_i
  end

  def self.hour time_string
    time_string.match(/^\d{1,2}/)[0].to_i
  end

  def self.minute time_string
    time_string.match(/\d{1,2}$/)[0].to_i
  end
end
