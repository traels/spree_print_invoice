require 'spec_helper'

feature 'Print Invoice', js: true do
  stub_authorization!

  given!(:user)   { create(:user, email: 'hi@futhr.io') }
  given(:address) { build(:address) }

  background do
    visit '/admin/orders'
  end

  context 'can not print' do
    # factory bug in spree_core no bill_address created
    given!(:order) { create(:order_with_line_items, user: user) }

    scenario 'when no shipped order exist' do
      uncheck 'Only show complete orders'
      click_button 'Filter Results'
      expect(page).to have_text user.email

      within('table#listing_orders') { find('.icon-edit').click }
      expect(page).not_to have_link 'Print Invoice'
    end
  end

  context 'can print' do
    # FIXME factory bug in spree_core no bill_address created
    # it also need complete payment so we dont need click thru filters
    given!(:order) { create(:shipped_order, user: user, bill_address: address) }

    background do
      reset_spree_preferences
      I18n.default_locale = :en
      SpreeI18n::Config.available_locales = [:en]
      SpreeI18n::Config.supported_locales = [:en]
    end

    scenario 'shipped orders' do
      uncheck 'Only show complete orders'
      click_button 'Filter Results'
      expect(page).to have_text user.email

      within('table#listing_orders') { find('.icon-edit').click }

      expect(page).to have_link 'Print Invoice'
      expect(page).to have_link 'Print Slip'
    end

    scenario 'when having only english locale' do
      uncheck 'Only show complete orders'
      click_button 'Filter Results'
      expect(page).to have_text user.email

      within('table#listing_orders') { find('.icon-edit').click }

      expect(page).to have_link 'Print Invoice'
      expect(page).to have_link 'Print Slip'

      pending 'SpreeI18n show all locales :('
      expect(page).not_to have_select 'print_invoice_language', selected: 'ENGLISH (US)'

      click_link 'Print Invoice'
      expect(current_path).to eq "admin/orders/#{order.id}.pdf?language=en&template=invoice"
    end

    context 'with more options' do
      background do
        reset_spree_preferences
        I18n.default_locale = :en
        SpreeI18n::Config.available_locales = [:en, :sv, :fi]
        SpreeI18n::Config.supported_locales = [:en, :sv, :fi]
      end

      scenario 'when having multiple locales' do
        uncheck 'Only show complete orders'
        click_button 'Filter Results'
        expect(page).to have_text user.email

        within('table#listing_orders') { find('.icon-edit').click }

        expect(page).to have_link 'Print Invoice'
        expect(page).to have_link 'Print Slip'
        expect(page).to have_select 'print_invoice_language', selected: 'ENGLISH (US)'

        within('select#print_invoice_language') do
          find('option[value=fi]').text.should eq 'SUOMI'
          pending 'its option for sv is english instead of swedish?'
          find('option[value=sv]').text.should eq 'SVENSKA'
        end

        select 'SVENSKA', from: 'print_invoice_language'
        click_link 'Print Invoice'
        expect(current_path).to eq "admin/orders/#{order.id}.pdf?language=sv&template=invoice"
      end
    end
  end
end
