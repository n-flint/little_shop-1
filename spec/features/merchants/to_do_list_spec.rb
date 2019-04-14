require 'rails_helper'

RSpec.describe 'Merchant Dashboard To-Do List' do
    # before :each do
    # end

  describe 'Items with defalut images' do
    it 'can see list of items that have default images' do
      merchant = create(:merchant)
      item_1 = create(:item, name: "Item 1", price: 10.00, inventory: 10, user: merchant, image: "https://target.scene7.com/is/image/Target/GUEST_848c9bef-75a4-4372-896d-4207a2278983?wid=488&hei=488&fmt=pjpeg")
      item_2 = create(:item, name: "Item 2", price: 20.00, inventory: 20, user: merchant)
      item_3 = create(:item, name: "Item 3", price: 30.00, inventory: 30, user: merchant)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_path
      # save_and_open_page

      within '.default-images' do
        expect(page).to_not have_content(item_1.name)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_3.name)
      end
    end
  end
end