module Spree
  class PrintInvoiceConfiguration < Preferences::Configuration
    preference :print_invoice_logo_path, :string, default: Spree::Config[:admin_interface_logo]
    preference :print_buttons,           :string, default: 'invoice'
    preference :page_size,               :string, default: 'LETTER'
    preference :page_layout,             :string, default: 'landscape'
  end
end
