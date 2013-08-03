module Spree
  module TestingSupport
    module I18nHelpers
      def set_default_locales
        reset_spree_preferences
        I18n.default_locale = :en
        SpreeI18n::Config.available_locales = [:en]
        SpreeI18n::Config.supported_locales = [:en]
      end
    end
  end
end
