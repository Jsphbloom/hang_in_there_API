class Api::V1::PostersController < ApplicationController

  def index
    all_posters = Poster.all
    if params[:sort] == "desc"
      all_posters = Poster.sort_by_desc
    elsif params[:sort] == "asc"
      all_posters = Poster.sort_by_asc
    end

    if params[:name]
      #Go to method to process filtering, needs argument(s) as well
      relevant_posters = Poster.filter_by_name(params[:name])
    end
  
    #Note: will not return records with a missing / nil price (# of records being returned in database was throwing me off at first!)
    if params[:min_price]
      relevant_posters = Poster.filter_by_price(params[:min_price], :min)
    elsif params[:max_price]
      relevant_posters = Poster.filter_by_price(params[:max_price], :max)
    end

    # render json: PosterSerializer.format_posters(all_posters)
    render json: PosterSerializer.format_posters(relevant_posters)
  end

  def create()
    created_poster = Poster.create(poster_params())
    render json: PosterSerializer.format_single_poster(created_poster)
    #Could refactor later further probably.  Is this ok to still have in controller, or is it 'too much'?
  end

  def destroy()
    #Returns code 200 by default, though instructions mentioned 204.  Checked with instructor - 200 code is fine.
    # render json: Poster.delete(params[:id], poster_params())
    #Apparently poster_params() cannot be run with delete()?  Perhaps because the route forces it to only send one parameter (so we're automatically safe)?
    render json: Poster.delete(params[:id])
  end
  
  def show
    render json: PosterSerializer.format_single_poster(Poster.find(params[:id]))
  end

  def update
    render json: Poster.update(params[:id], poster_params)
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