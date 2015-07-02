class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

before_action :set_cart, only: [:new, :create]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate(page: params[:page], per_page: 2)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def express
  response = EXPRESS_GATEWAY.setup_purchase(current_cart.build_order.price_in_cents,
    :ip                => request.remote_ip,
    :return_url        => new_order_url,
    :cancel_return_url => products_url
  )
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

def new
  @order = Order.new(:express_token => params[:token])
end
 def order_images
    @orders = Order.all
    respond_to do |format|
      format.js
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
   def create
      @order = Order.new(order_params)
      
      if @order.save
        # Tell the UserMailer to send a welcome email after save
        UserMailer.welcome_email(@order).deliver_now
        redirect_to orders_path
      else
        render :action => 'new'
      end
    end


  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def purchase
  response = process_purchase
  transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
  cart.update_attribute(:purchased_at, Time.now) if response.success?
  response.success?
end

def express_token=(token)
  write_attribute(:express_token, token)
  if new_record? && !token.blank?
    details = EXPRESS_GATEWAY.details_for(token)
    self.express_payer_id = details.payer_id
    self.first_name = details.params["first_name"]
    self.last_name = details.params["last_name"]
  end
end

private

def process_purchase
  if express_token.blank?
    STANDARD_GATEWAY.purchase(price_in_cents, credit_card, standard_purchase_options)
  else
    EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
  end
end

def standard_purchase_options
  {
    :ip => ip_address,
    :billing_address => {
      :name     => "Ryan Bates",
      :address1 => "123 Main St.",
      :city     => "New York",
      :state    => "NY",
      :country  => "US",
      :zip      => "10001"
    }
  }
end

def express_purchase_options
  {
    :ip => ip_address,
    :token => express_token,
    :payer_id => express_payer_id
  }
end

def validate_card
  if express_token.blank? && !credit_card.valid?
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end
end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :gender_type, :address, :email, :password, :accno, :pay_type ,:express)
    end
end
