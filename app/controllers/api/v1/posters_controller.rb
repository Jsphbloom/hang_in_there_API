class Api::V1::PostersController < ApplicationController
  def index
    render json: PosterSerializer.format_posters(Poster.all)
  end

  def create
    binding.pry
    Poster.create(task_params())

    binding.pry

    #Two ways to do this.
    #1. 'Cheap' way: create new object, save to DB, and format info from the object created.  Problem: we don't really know it's data in the DB, and we don't get id, etc.
    #2. Full way: query the DB and return the relevant entry as an object to then serialize.
    #This functionality should probably be eventually added to the model, yes?
    created_poster = Poster.order(created_at: :desc).limit(1)

    #Also expected to return JSON content!  What is the object to pass to this?  Poster.self / similar?
    render json: PosterSerializer.format_created_poster(created_poster)

  end


  private

  def task_params()
    #For data validation purposes - STILL NEEDS MORE TESTING (will it accept other fields in the request and just ignore them?)
    params.require(:poster).permit(:name, :description, :img_url, :price, :year, :vintage)
    # params.permit(:name, :description, :img_url, :price, :year, :vintage)
  end
end