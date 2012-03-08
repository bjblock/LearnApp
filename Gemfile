source 'https://rubygems.org'

gem 'rails', '3.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
	gem 'pg'
end

group :development do
	gem 'sqlite3'
end

group :test do
	gem 'ruby-debug19', :require => 'ruby-debug'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'ruby-ole-patched-for-home_run'
gem 'rubyzip', :require => 'zip/zipfilesystem'         # required for roo
gem 'spreadsheet'     # require for roo
gem 'nokogiri'

gem 'jquery-rails'
gem 'roo'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'