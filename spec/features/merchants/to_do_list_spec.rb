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

      within '.default-images' do
        expect(page).to_not have_content(item_1.name)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_3.name)
      end
    end

    it 'list of items that have default images are links to edit page' do
      merchant = create(:merchant)
      item_1 = create(:item, name: "Item 1", price: 10.00, inventory: 10, user: merchant)
      item_2 = create(:item, name: "Item 2", price: 20.00, inventory: 20, user: merchant)
      item_3 = create(:item, name: "Item 3", price: 30.00, inventory: 30, user: merchant)
      oi_1 = create(:fulfilled_order_item)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit dashboard_path

      within '.default-images' do
        click_link item_2.name
      end

      expect(current_path).to eq(edit_dashboard_item_path(item_2))
    end
  end

  describe 'unfulfilled items statistics' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @item_1 = create(:item, name: "Item 1", price: 50, inventory: 10, user: @merchant_1)
      @item_2 = create(:item, name: "Item 2", price: 20, inventory: 10, user: @merchant_1)
      @item_3 = create(:item, name: "Item 3", price: 70, inventory: 10, user: @merchant_1)
      @item_4 = create(:item, name: "Item 4", price: 70, inventory: 10, user: @merchant_2)

      @user = create(:user)
      @order_1 = create(:order, user: @user)
      @order_2 = create(:order, user: @user)
      @order_3 = create(:order, user: @user)
      @order_4 = create(:order, user: @user)
      @shipped_order_5 = create(:shipped_order, user: @user)
      create(:order_item, order: @order_1, item: @item_1, quantity: 10, price: 10)
      create(:order_item, order: @order_2, item: @item_2, quantity: 10, price: 20)
      create(:order_item, order: @order_3, item: @item_3, quantity: 10, price: 30)
      create(:order_item, order: @order_4, item: @item_4, quantity: 10, price: 40)
      create(:fulfilled_order_item, order: @shipped_order_5, item: @item_4, quantity: 10, price: 50)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_1)

      visit dashboard_path
    end

    it 'can see a statistic about unfulfilled items' do
      within '.unfulfilled-items' do
        expect(page).to have_content('You have 3 unfulfilled orders worth $600.00')
      end
    end

    it 'sees a warning if item ordered exceeds the quantity' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: "Item 1", price: 50, inventory: 10, user: merchant_1)
      item_2 = create(:item, name: "Item 2", price: 20, inventory: 10, user: merchant_1)
      item_3 = create(:item, name: "Item 3", price: 70, inventory: 10, user: merchant_1)
      user = create(:user)
      order_1 = create(:order, user: user)
      order_2 = create(:order, user: user)
      order_3 = create(:order, user: user)
      order_4 = create(:order, user: user)
      create(:order_item, order: order_1, item: item_1, quantity: 10, price: 500)
      create(:order_item, order: order_2, item: item_1, quantity: 10, price: 500)
      create(:order_item, order: order_3, item: item_2, quantity: 5, price: 350)
      create(:order_item, order: order_4, item: item_3, quantity: 4, price: 280)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_path

      within "#order-#{order_1.id}" do
        expect(page).to have_content('An item in this order exceeds your inventory')
      end
    end
    

    it 'sees a warning if multiple orders exist for single item with quantity abouve merchants inventory' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: "Item 1", price: 50, inventory: 10, user: merchant_1)
      item_2 = create(:item, name: "Item 1", price: 50, inventory: 10, user: merchant_1)
      user = create(:user)
      order_1 = create(:order, user: user)
      order_2 = create(:order, user: user)

      create(:order_item, order: order_1, item: item_1, quantity: 10, price: 500)
      create(:order_item, order: order_2, item: item_1, quantity: 10, price: 500)
      create(:order_item, order: order_2, item: item_2, quantity: 10, price: 500)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_path
      
      within '.unfulfilled-items' do
        expect(page).to have_content("Multiple Orders Exist For #{item_1.name}: Exceeds Inventory")
      end
    end
  end
end