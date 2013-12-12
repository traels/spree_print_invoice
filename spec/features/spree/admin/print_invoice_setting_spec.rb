require 'spec_helper'

feature 'Settings for Print Invoice', js: true do
  stub_authorization!

  scenario 'update' do
    visit '/admin'
    click_link 'Configuration'
    click_link 'Print Invoice Settings'

    #fill_in 'preferences_print_invoice_logo_path', with: '/somewhere/logo.png'
    fill_in 'preferences_print_buttons', with: 'invoice,packaging_slip'
    select  'A4', from: 'preferences_page_size'
    select  'portrait', from: 'preferences_page_layout'
    fill_in 'preferences_footer_left', with: 'left text..'
    fill_in 'preferences_footer_right', with: 'right text..'
    fill_in 'preferences_return_message', with: 'dough!'
    fill_in 'preferences_anomaly_message', with: 'hua!'

    click_button 'Update'

    setting = Spree::PrintInvoiceSetting.new
    #setting[:print_invoice_logo_path].should eq '/somewhere/logo.png'
    setting[:print_buttons].should eq 'invoice,packaging_slip'
    setting[:page_size].should eq 'A4'
    setting[:page_layout].should eq 'portrait'
    setting[:footer_left].should eq 'left text..'
    setting[:footer_right].should eq 'right text..'
    setting[:return_message].should eq 'dough!'
    setting[:anomaly_message].should eq 'hua!'
  end
end
