module SpreePrintInvoice
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_print_invoice\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_print_invoice\n", before: /\*\//, verbose: true
      end
    end
  end
end
