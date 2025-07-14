# CurrencyConverter

**CurrencyConverter** é uma gem Ruby simples para conversão de moedas, com suporte a taxas atuais e históricas, usando a API gratuita do [exchangerate.host](https://exchangerate.host/).

## ✨ Recursos

- Conversão entre duas moedas com taxa atual
- Consulta das taxas ao vivo de múltiplas moedas
- Consulta de taxas históricas em uma data específica
- Suporte a configuração por `.env` ou programaticamente

## 🔧 Instalação

Adicione esta linha ao seu `Gemfile`:

```ruby
gem 'currency_converter', path: 'https://github.com/GodKelvin/currency_converter.git',  tag: 'v0.1.0'
```

E depois execute:

```bash
bundle install
```

Ou instale diretamente com:

```bash
gem build currency_converter.gemspec
gem install currency_converter-*.gem
```

## 🔑 Obtendo a chave da API

1. Vá para: [https://exchangerate.host/#/](https://exchangerate.host/#/)
2. Clique em **Get Free API Key**
3. Registre-se com seu e-mail
4. Você receberá um **access_key**, copie-o

## 🛠️ Configuração

Você pode configurar a chave da API de duas formas:

### 1. Via arquivo `.env`

Crie um arquivo `.env` na raiz do seu projeto:

```env
EXCHANGE_RATE_API_KEY=sua_chave_aqui
```

E certifique-se de que a gem [`dotenv`](https://github.com/bkeepers/dotenv) esteja carregada. No seu código principal:

```ruby
require 'dotenv'
Dotenv.load
```

### 2. Manualmente no código

```ruby
CurrencyConverter.configure do |config|
  config.access_key = "sua_chave_aqui"
end
```

## 📦 Uso

### Conversão de valores (`convert`)

```ruby
require 'currency_converter'

result = CurrencyConverter.convert(100, from: 'USD', to: 'BRL')
puts "100 USD em BRL: #{result}"
```

### Taxas ao vivo (`live`)

Retorna taxas de câmbio em tempo real com base na moeda base.

```ruby
CurrencyConverter.live(base: 'USD', currencies: ['EUR', 'GBP'])
# => { "USDEUR"=>0.91, "USDGBP"=>0.78, ... }
```

Se `currencies` for omitido, retorna todas as taxas disponíveis.

### Taxas históricas (`historical`)

Consulta taxas de uma data específica (formato `YYYY-MM-DD`):

```ruby
CurrencyConverter.historical(date: '2024-01-01', base: 'EUR', currencies: ['USD', 'JPY'])
# => { "EURUSD"=>1.09, "EURJPY"=>157.15 }
```

## ❗ Tratamento de erros

- Se a requisição falhar ou os parâmetros forem inválidos, uma exceção `CurrencyConverter::Error` será lançada.
- Certifique-se de capturar exceções onde apropriado:

```ruby
begin
  CurrencyConverter.convert(100, from: 'USD', to: 'EUR')
rescue CurrencyConverter::Error => e
  puts "Erro na conversão: #{e.message}"
end
```

## 📁 Estrutura do Projeto

```
currency_converter/
├── lib/
│   ├── currency_converter.rb
│   ├── currency_converter/version.rb
│   └── currency_converter/configuration.rb
├── .env
├── currency_converter.gemspec
└── README.md
```

## 📄 Licença

Esta gem é open-source sob a licença MIT.

## 🤝 Contribuições

Pull requests são bem-vindos! Para grandes mudanças, por favor, abra uma issue primeiro para discutir o que você gostaria de modificar.

## 📬 Contato

Linkedin: [Kelvin Lehrback](https://www.linkedin.com/in/kelvin-lehrback/)
