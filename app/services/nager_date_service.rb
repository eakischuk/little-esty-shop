class NagerDateService
  def self.get_holidays
    response = Faraday.get("https://date.nager.at/api/v2/NextPublicHolidays/US")
    JSON.parse(response.body, symbolize_names: true)
  end
end
