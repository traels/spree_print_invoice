require 'spec_helper'

feature 'Settings for Print Invoice', js: true do
  given!(:admin) { create(:admin_user) }

  scenario 'update settings' do
    visit '/admin'
    fill_in 'spree_user_password', with: 'secret'
    fill_in 'spree_user_email', with: admin.email
    click_button 'Login'

    click_link 'Configuration'
    click_link 'Print Invoice Settings'

    fill_in 'preferences_print_invoice_logo_path', with: '/somewhere/logo.png'

    click_button 'Update'

    setting = Spree::PrintInvoiceSetting.new
    expect(setting[:print_invoice_logo_path]).to eq '/somewhere/logo.png'
  end
end
