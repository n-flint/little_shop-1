class Dashboard::DashboardController < Dashboard::BaseController
  def index
    @merchant = current_user
    @pending_orders = Order.pending_orders_for_merchant(current_user.id)
    
  end

  def existing
    merchant = current_user if current_merchant?
    @users = User.existing_customers(merchant.id)
    
    respond_to do |format|
      format.csv { send_data @users.existing_to_csv(merchant.id)}
    end
  end
  
  def potential
    merchant = current_user if current_merchant?
    @users = User.potential_customers(merchant.id)
    
    respond_to do |format|
      format.csv { send_data @users.potential_to_csv}
    end
  end
end