source 'https://rubygems.org'

ruby '2.1.3'

gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'bcrypt'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'kaminari'
gem 'simple_form'
gem 'squeel'
gem 'devise'
gem 'whenever', require: false
gem 'enumerize'
gem 'gretel'
gem 'carrierwave'

group :development do
  # productionがPostgreSQLなのであれば、ローカルでの開発もPostgreSQLを使った方が、デプロイ時に障害が起こる可能性は低くなるかと思います
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'erb2haml'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'spring'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'launchy'
end

group :production do
  gem 'pg'
end
