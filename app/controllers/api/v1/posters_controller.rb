class Api::V1::PostersController < ApplicationController

  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end

  def show
    render json: PosterSerializer.format_single_poster(Poster.find(params[:id]))
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  private

  def poster_params
    params.require(:data).require(:attributes).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end