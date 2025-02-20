class Api::V1::PostersController < ApplicationController
  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end

  def create
    # binding.pry
    # Poster.create(poster_params())

    created_poster = Poster.create(poster_params())
    render json: PosterSerializer.format_created_poster(created_poster)
    #Could refactor later further probably.  Is this ok to still have in controller, or is it 'too much'?


    
    #Two ways to do this.
    #1. 'Cheap' way: create new object, save to DB, and format info from the object created.  Problem: we don't really know it's data in the DB, and we don't get id, etc.
    # created_poster = Poster.new(params[:poster])      #This doesn't seem to fully work
    
    # created_poster = Poster.new() do |p|
    #   p.name = params[:poster][:name]
    #   p.description = params[:poster][:description]
    #   p.price = params[:poster][:price]
    #   p.year = params[:poster][:year]
    #   p.vintage = params[:poster][:vintage]
    #   p.img_url = params[:poster][:img_url]
    # end

    # binding.pry

    # created_poster.save()
    # #2. Full way: query the DB and return the relevant entry as an object to then serialize.
    # #This functionality should probably be eventually added to the model, yes?
    # # created_poster = Poster.order(created_at: :desc).limit(1)

    # binding.pry

    # #NOTE: this is NOT fully returning a poster object, even though it looks like it.  Doesn't have access to id, description, etc.  WHY?!
    
    # # binding.pry

    
  end
  
  
  private
  
  def poster_params()
    #For data validation purposes - STILL NEEDS MORE TESTING (will it accept other fields in the request and just ignore them?)
    params.require(:poster).permit(:name, :description, :img_url, :price, :year, :vintage)
    #Joe did it this way and it worked as well:
    # params.require(:data).require(:attributes).permit(:name, :description, :img_url, :price, :year, :vintage)
    # params.permit(:name, :description, :img_url, :price, :year, :vintage)
  end
end