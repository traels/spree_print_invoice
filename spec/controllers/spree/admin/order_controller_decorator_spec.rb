require 'spec_helper'

describe Spree::Admin::OrdersController do
  stub_authorization!

  let(:user) { create(:user) }

  before { controller.stub spree_current_user: user }

  context '#show' do
    specify do
    end
  end

  context '#save_current_locale' do
    specify do
    end
  end

  context '#current_locale' do
    specify do
    end
  end
end
