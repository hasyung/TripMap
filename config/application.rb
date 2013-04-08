require File.expand_path('../boot', __FILE__)
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
#exporting cvs
require 'csv'
require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module TripMap
  class Application < Rails::Application

    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Beijing'

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'

    config.encoding = "utf-8"

    config.filter_parameters += [:password]

    config.active_support.escape_html_entities_in_json = true

    config.active_record.whitelist_attributes = true
    
    config.active_record.observers = :trip_map_observer

    config.assets.enabled = true

    config.assets.version = '1.0'

    config.cache_store = :memory_store
  end
end

Dir[File.join(Rails.root, "lib", "core", "*.rb")].each {|l| require l }