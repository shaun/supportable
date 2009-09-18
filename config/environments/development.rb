# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false


config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address  => "localhost",
  :port  => 25,
  :domain => `hostname`.chomp
}


require 'memcache'

config.action_controller.session_store = :mem_cache_store

memcache_options = {
  :c_threshold => 10_000,
  :compression => true,
  :debug => false,
  :namespace => "supportable-#{RAILS_ENV}",
  :readonly => false,
  :urlencode => false
}

main_cache_options = memcache_options.merge({:namespace => "supportable-#{RAILS_ENV}"})
config.cache_store = :mem_cache_store, 'localhost:11211', main_cache_options

SESSION_CACHE = MemCache.new memcache_options
SESSION_CACHE.servers = 'localhost:11211'

CACHE = MemCache.new main_cache_options
CACHE.servers = 'localhost:11211'

ActionController::Base.session_options[:expires] = 1800
ActionController::Base.session_options[:cache] = SESSION_CACHE