module SpreePrintInvoice
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_print_invoice\n"
      end
    end
  end
end
