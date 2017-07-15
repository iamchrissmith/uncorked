class Manager::VenuesController < ApplicationController

  before_action :set_venue, only: [:edit, :show, :update]
  before_action :require_user

  def new
    @venue = Venue.new
  end

  def create
    @venue = current_user.venues.create(venue_params)

    if @venue.save
      redirect_to manager_venue_path(@venue), success: "Venue Successfully Created"
    else
      render :new
    end
  end

  def show
  end

  def index
    @venues = current_user.venues.paginate(:page => params[:page], :per_page => 30)
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    if @venue.update(venue_params)
      redirect_to venue_path(@venue), success: "Venue updated"
    else
      render :edit
    end
  end

  private
    def venue_params
      params.require(:venue).permit(:name, :street_address, :city, :state, :zip)
    end

    def set_venue
      @venue = Venue.find(params[:id])
    end

    def require_user
      unless current_user && current_user.manager?
        redirect_to root_path, warning: "You do not have permission to access this page."
      end
    end

end
