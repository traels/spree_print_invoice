module Spree
  class PrintInvoiceConfiguration < Preferences::Configuration
    preference :print_invoice_logo_path, :string, default: Spree::Config[:admin_interface_logo]
    preference :print_buttons,           :string, default: 'invoice,packaging_slip'
    preference :page_size,               :string, default: 'LETTER'
    preference :page_layout,             :string, default: 'landscape'
    preference :footer_left,             :string, default: 'Your company name and address'
    preference :footer_right,            :string, default: 'Your phone and email'
  end
end
