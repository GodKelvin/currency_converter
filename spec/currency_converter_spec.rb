# frozen_string_literal: true

require "spec_helper"
require_relative "../lib/currency_converter"
RSpec.describe CurrencyConverter do
  before do
    # Configure a API key fake (se necessário)
    CurrencyConverter.configure do |config|
      config.access_key = "test_key"
    end
  end

  describe ".convert" do
    it "converte corretamente de USD para BRL" do
      stub = {
        "result" => 5.25
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: stub))

      result = described_class.convert(1, from: "USD", to: "BRL")
      expect(result).to eq(5.25)
    end

    it "lança erro se amount não for numérico" do
      expect do
        described_class.convert("dez", from: "USD", to: "BRL")
      end.to raise_error(ArgumentError, /Amount must be a number/)
    end
  end

  describe ".live" do
    it "retorna as cotações atuais de moedas" do
      stub = {
        "quotes" => { "USDEUR" => 0.91, "USDBRL" => 5.25 }
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: stub))

      result = described_class.live(base: "USD", currencies: %w[EUR BRL])
      expect(result).to eq("USDEUR" => 0.91, "USDBRL" => 5.25)
    end
  end

  describe ".historical" do
    it "retorna as taxas históricas para uma data" do
      stub = {
        "quotes" => { "USDEUR" => 0.89 }
      }

      allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: stub))

      result = described_class.historical(date: "2023-07-10", base: "USD", currencies: ["EUR"])
      expect(result).to eq("USDEUR" => 0.89)
    end

    it "lança erro se a data estiver em formato inválido" do
      expect do
        described_class.historical(date: "10-07-2023", base: "USD", currencies: ["EUR"])
      end.to raise_error(ArgumentError, /Date must be in YYYY-MM-DD format/)
    end
  end
end
