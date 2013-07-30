module SpreePrintInvoice
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_print_invoice\n"
      end

      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_print_invoice\n", before: /\*\//, verbose: true
      end
    end
  end
end
