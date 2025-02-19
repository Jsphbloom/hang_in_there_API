class Api::V1::PostersController < ApplicationController
  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end
end