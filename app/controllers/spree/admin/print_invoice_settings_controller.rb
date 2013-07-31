module Spree
  module Admin
    class PrintInvoiceSettingsController < ResourceController

      # save settings
      def update
        settings = Spree::PrintInvoiceSetting.new
        params[:preferences].each do |k,v|
          settings[k] = v
        end
        flash[:success] = Spree.t(:successfully_updated, scope: :print_invoice)
        render :edit
      end
    end
  end
end