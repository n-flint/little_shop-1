class Dashboard::DashboardController < Dashboard::BaseController
  def index
    @merchant = current_user
    @pending_orders = Order.pending_orders_for_merchant(current_user.id)
    
  end

  def existing
    @users = User.all
    
    respond_to do |format|
      format.csv { send_data @users.to_csv}
    end
  end
  
  def potential
    @users = User.all
    
    respond_to do |format|
      format.csv { send_data @users.to_csv}
    end
  end
end