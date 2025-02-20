class Api::V1::PostersController < ApplicationController
  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end

  def create
    created_poster = Poster.create(poster_params())
    render json: PosterSerializer.format_created_poster(created_poster)
    #Could refactor later further probably.  Is this ok to still have in controller, or is it 'too much'
  end

  def destroy()
    #Just 204 status needs to be returned, no additional content.  Right now returning code 200.  May need adjusting.
    # render json: Poster.delete(params[:id], poster_params())
    #Apparently poster_params() cannot be run with delete()?  Perhaps because the route forces it to only send one parameter (so we're automatically safe)?
    render json: Poster.delete(params[:id])
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