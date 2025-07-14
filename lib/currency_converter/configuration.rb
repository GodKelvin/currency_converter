# frozen_string_literal: true

# Classe responsável pela configuração da gem CurrencyConverter,
module CurrencyConverter
  # incluindo o gerenciamento da chave de API.
  class Configuration
    attr_writer :access_key

    def access_key
      @access_key || ENV["EXCHANGE_RATE_API_KEY"]
    end
  end
end
