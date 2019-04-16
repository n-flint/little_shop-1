require 'rails_helper'

RSpec.describe 'Merchant Dashboard Page' do
  describe 'As A Merchant' do
    it 'sees a link to download csv of existing customers' do
      @merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_path

      click_link "Existing Customers"
    end

    it 'sees a link to download csv of potential customers' do
      @merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_path

      click_link "Potential Customers"
    end
  end
end