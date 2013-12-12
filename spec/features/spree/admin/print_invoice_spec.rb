require 'spec_helper'

feature 'Print Invoice' do
  stub_authorization!

  given!(:user)   { create(:user, email: 'hi@futhr.io') }
  given(:address) { build(:address) }

  background do
    visit '/admin/orders'
  end

  context 'can not print' do
    given!(:order) { create(:order_with_line_items, user: user) }

    scenario 'when no shipped order exist' do
      navigate_thru_filters_with order

      within_table('listing_orders') { click_icon :edit }
      expect(page).not_to have_link 'Print Invoice'
    end
  end

  context 'can print' do
    # no bill_address set?
    # it also need complete payment so we dont need click thru filters
    given!(:order) do
      create(:shipped_order,
        user: user,
        bill_address: address)
    end

    background do
      set_global_locales [:en]
    end

    xscenario 'shipped order factory' do
      order.user.email.should eq 'hi@futhr.io'
      order.bill_address.company.should eq 'Company'
      order.ship_address.company.should eq 'Company'
      order.completed_at.should_not be_nil
      order.payment_state.should eq 'balance_due'
    end

    scenario 'shipped orders' do
      navigate_thru_filters_with order

      within_table('listing_orders') { click_icon :edit }

      expect(page).to have_link 'Print Invoice'
      expect(page).to have_link 'Print Slip'
    end

    scenario 'when having only english locale' do
      navigate_thru_filters_with order

      within_table('listing_orders') { click_icon :edit }

      expect(page).to have_link 'Print Invoice'
      expect(page).to have_link 'Print Slip'

      expect(page).not_to have_select 'print_invoice_language'

      show_invoice_pdf_for order
    end

# test disabled as code for invoice switch is also disabled
#    context 'with more options' do
#      background do
#        set_global_locales [:en, :sv, :fi]
#      end
#
#      scenario 'when having multiple locales' do
#        navigate_thru_filters_with order
#
#        within_table('listing_orders') { click_icon :edit }
#
#        expect(page).to have_link 'Print Invoice'
#        expect(page).to have_link 'Print Slip'
#        expect(page).to have_select 'print_invoice_language', selected: 'ENGLISH (US)'
#
#        # within('select#print_invoice_language') do
#        #   find('option[value=fi]').text.should eq 'SUOMI'
#        #   find('option[value=sv]').text.should eq 'SVENSKA'
#        # end
#
#        pending 'select2 helpers require label'
#        select 'SUOMI', from: 'ENGLISH (US)'
#        select 'SVENSKA', from: 'ENGLISH (US)'
#
#        show_invoice_pdf_for order
#      end
#    end
  end

  private

  def set_global_locales(locales)
    reset_spree_preferences
    I18n.default_locale = locales.first
    I18n.available_locales = locales
    SpreeI18n::Config.available_locales = locales
    SpreeI18n::Config.supported_locales = locales
  end

  def navigate_thru_filters_with(order)
    uncheck 'Only show complete orders'
    click_button 'Filter Results'
    expect(page).to have_text order.user.email
  end

  def show_invoice_pdf_for(order)
    pending 'order has no bill address'
    click_link 'Print Invoice'
    expect(current_path).to eq "admin/orders/#{order.number}.pdf?language=en&template=invoice"
    # expect(current_path).to eq "admin/orders/en/invoice/#{order.number}.pdf" # ideal url
    expect(page.response_headers['Content-Type']).to eq 'application/pdf'
    expect(page.response_headers['Content-Disposition']).to eq "attachment; filename=#{order.number}.pdf"
  end
end
