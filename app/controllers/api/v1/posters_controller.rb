class Api::V1::PostersController < ApplicationController
  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end
  def show
    render json: PosterSerializer.format_single_poster(Poster.find(params[:id]))
  end
end