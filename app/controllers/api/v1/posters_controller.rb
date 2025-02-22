class Api::V1::PostersController < ApplicationController

  def index
    #Default behavior (no query):
    relevant_posters = Poster.all
    
    #Queries:
    if params[:sort] == "desc"
      relevant_posters = Poster.sort_by_desc
    elsif params[:sort] == "asc"
      relevant_posters = Poster.sort_by_asc
    end

    if params[:name]
      relevant_posters = Poster.filter_by_name(params[:name])
    end
  
    if params[:min_price]
      relevant_posters = Poster.filter_by_price(params[:min_price], :min)
    elsif params[:max_price]
      relevant_posters = Poster.filter_by_price(params[:max_price], :max)
    end

    render json: PosterSerializer.format_posters(relevant_posters)
  end

  def create()
    created_poster = Poster.create(poster_params())
    render json: PosterSerializer.format_single_poster(created_poster)
    #Could refactor later further probably.  Is this ok to still have in controller, or is it 'too much'?
  end

  def destroy()
    #Returns code 200 by default via Rails, though instructions mentioned 204 at one point.  Checked with instructor - 200 code is fine.
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
    params.require(:poster).permit(:name, :description, :img_url, :price, :year, :vintage)
  end
  
end