require 'spec_helper'

feature 'Print Invoice', js: true do
  stub_authorization!

  background do
    2.times { create(:order) }
    # visit spree.admin_path
    # page!
  end

  scenario 'can print' do
  end
end
