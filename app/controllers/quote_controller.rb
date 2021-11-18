class QuoteController < ApplicationController
  def create 
    @quote = Quote.new(quote_params)
    type_service
    @quote.numApartment = params[:quote][:numBusinessRooms] if params[:quote][:numBusinessRooms].present?
    @quote.numFloor = params[:quote][:numFloorHyb] if params[:quote][:numFloorHyb].present?
    calcul_total
    if @quote.save
      flash[:notice] = 'Quote created successfully'
      redirect_to pages_quote_url action: :new
    else
      render :new 
    end
    zendesk
  end

  def zendesk
    ZendeskAPI::Ticket.new($client, :id => 1, :priority => "urgent") # doesn't actually send a request, must explicitly call #save!
    ZendeskAPI::Ticket.create!($client, :type => "task", :subject => "#{@quote.compagnyName}", :comment => { :value => "Comment: The company #{@quote.compagnyName} as made a quote for a building of type #{@quote.type_building} and wants the #{@quote.typeService} service. 
                                                                                                       Quote information
                                                                                                       Number of Elevator: #{@quote.numElevator}
                                                                                                       Total Elevators Price:#{@quote.totalElevatorPrice}
                                                                                                       Installation Fees: #{@quote.installationFees}
                                                                                                       Total: #{@quote.total}"}, :submitter_id => $client.current_user.id , :priority => "urgent")
  end 

  private
  def quote_params
    params.require(:quote).permit(:type_building, :numApartment, :numFloor, :numElevator, :numOccupant, :compagnyName, :email, :typeService, :totalElevatorPrice, :total, :installationFees) 
  end

  private
  def type_service
    if @quote.typeService == "1" then
      @quote.typeService = "Standard"
    end
    if @quote.typeService == "2" then
      @quote.typeService = "Premium"
    end
    if @quote.typeService == "3" then
      @quote.typeService = "Excellium"
    end
  end

  private
  def calcul_total
    if @quote.typeService == "Standard" then
      @quote.totalElevatorPrice = @quote.numElevator * 7565
      @quote.installationFees = @quote.totalElevatorPrice * 0.10
      @quote.total = @quote.totalElevatorPrice + @quote.installationFees
    end
    if @quote.typeService == "Premium" then
      @quote.totalElevatorPrice = @quote.numElevator * 12345
      @quote.installationFees = @quote.totalElevatorPrice * 0.13
      @quote.total = @quote.totalElevatorPrice + @quote.installationFees
    end
    if @quote.typeService == "Excellium" then
      @quote.totalElevatorPrice = @quote.numElevator * 15400
      @quote.installationFees = @quote.pricePerElevator * 0.16
      @quote.total = @quote.totalElevatorPrice + @quote.installationFees
    end
  end
end