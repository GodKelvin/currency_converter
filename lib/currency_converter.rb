# frozen_string_literal: true

require "httparty"
require_relative "currency_converter/version"
require "dotenv"
require_relative "currency_converter/configuration"

Dotenv.load

# CurrencyConverter é uma gem para conversão de moedas usando a API exchangerate.host.
module CurrencyConverter
  class Error < StandardError; end
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def convert(amount, from:, to:)
      raise ArgumentError, "Amount must be a number" unless amount.is_a?(Numeric)
      raise ArgumentError, "Currency codes must be 3-letter strings" unless valid_code?(from) && valid_code?(to)

      api_key = configuration&.access_key || ENV["EXCHANGE_RATE_API_KEY"]
      response = HTTParty.get("https://api.exchangerate.host/convert", query: {
                                from: from.upcase,
                                to: to.upcase,
                                amount: amount,
                                access_key: api_key
                              })
      raise Error, "API request failed" unless response.success?

      response.parsed_response["result"]
    end

    def live(base: "USD", currencies: nil)
      api_key = configuration&.access_key || ENV["EXCHANGE_RATE_API_KEY"]
      query = { base: base.upcase, access_key: api_key }
      query[:currencies] = currencies.map(&:upcase).join(",") if currencies

      response = HTTParty.get("https://api.exchangerate.host/live", query: query)
      raise Error, "API request failed" unless response.success?

      response.parsed_response["quotes"]
    end

    def historical(date:, base: "USD", currencies: nil)
      raise ArgumentError, "Date must be in YYYY-MM-DD format" unless date =~ /\A\d{4}-\d{2}-\d{2}\z/

      api_key = configuration&.access_key || ENV["EXCHANGE_RATE_API_KEY"]
      query = {
        base: base.upcase,
        date: date,
        access_key: api_key
      }
      query[:currencies] = currencies.map(&:upcase).join(",") if currencies

      response = HTTParty.get("https://api.exchangerate.host/historical", query: query)
      raise Error, "API request failed" unless response.success?

      response.parsed_response["quotes"]
    end

    private

    def valid_code?(code)
      code.is_a?(String) && code.length == 3
    end
  end
end
