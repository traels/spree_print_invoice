module Spree
  module TestingSupport
    module I18nHelpers
      def set_default_locales
        reset_spree_preferences
        locales = [:en]
        I18n.default_locale = locales.first
        I18n.available_locales = locales
        SpreeI18n::Config.available_locales = locales
        SpreeI18n::Config.supported_locales = locales
      end
    end
  end
end
