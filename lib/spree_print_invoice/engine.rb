module Spree
  module PrintInvoice
    def self.config(&block)
      yield(Spree::GoogleBase::Config)
    end
  end
end

module SpreePrintInvoice
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_print_invoice'

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree.print_invoice.environment', before: :load_config_initializers do |app|
      Spree::PrintInvoice::Config = Spree::PrintInvoiceConfiguration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
