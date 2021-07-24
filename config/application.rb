require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Folcrawler
  class Application < Rails::Application
    config.load_defaults 6.1
    config.generators.system_tests = nil
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    config.i18n.default_locale = 'pt-BR'
  end
end
