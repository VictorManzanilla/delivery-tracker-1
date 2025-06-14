class DeliveriesController < ApplicationController
  def index
    

     @waiting_on = Delivery.where(user_id: current_user.id, arrived: [false, nil])
    @received = Delivery.where(user_id: current_user.id, arrived: true)

    render({ :template => "deliveries/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show" })
  end

  def create
    the_delivery = Delivery.new
    the_delivery.user_id = current_user.id
    the_delivery.description = params.fetch("query_description")
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.details = params.fetch("query_details")
    the_delivery.arrived = false

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    
    @the_delivery = Delivery.where({ :id => the_id }).at(0)
    if @the_delivery.nil?
      redirect_to("/deliveries", alert: "Delivery not found.")
      return
    end

    # Update the 'arrived' boolean if submitted
    if params[:arrived] == "true"
      @the_delivery.arrived = true
    end

    # @the_delivery.user_id = current_user.id
    # @the_delivery.description = params.fetch("query_description")
    # @the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    # @the_delivery.details = params.fetch("query_details")

    if @the_delivery.valid?
   
      @the_delivery.save
     redirect_to("/deliveries", notice: "Marked delivery #{@the_delivery.id} as received.")
    else
      redirect_to("/deliveries", { :alert => @the_delivery.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)
   

    the_delivery.destroy

    redirect_to("/deliveries", { :notice => "Delivery deleted successfully."} )
  end
end
