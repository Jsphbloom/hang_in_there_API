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
    #Iteration 4 update:
    missing_attributes = check_attributes_present()

     binding.pry

    if missing_attributes != []
      response.status = 422
      render json: PosterSerializer.return_missing_attrs_error(missing_attributes)
    else
      #We still need to verify that the requested new poster's name doesn't already exist (i.e. it's unique)
      if !Poster.verify_unique(params)
        response.status = 418
        render json: { "message": "duplicate yo" }
      else
       
        # binding.pry

        render json: PosterSerializer.format_single_poster(Poster.create(poster_params()))
      end
    end


    #Could refactor later further probably.  Is this ok to still have in controller, or is it 'too much'?
  end

  def destroy()
    #Returns code 200 by default via Rails, though instructions mentioned 204 at one point.  Checked with instructor - 200 code is fine.
    render json: Poster.delete(params[:id])
  end
  
  def show
    found_poster = Poster.find_by(id: params[:id])
    if !found_poster
      #Manually set the status (is there a better way?)
      response.status = 404
      render json: PosterSerializer.return_error()              #NOTE: do we have to adjust any tests for this?
    else
      render json: PosterSerializer.format_single_poster(found_poster)
    end
  end

  def update
    # #Iteration 4 update:
    # missing_attributes = check_attributes_present()

    # # binding.pry

    # if missing_attributes != []
    #   response.status = 422
    #   render json: PosterSerializer.return_missing_attrs_error(missing_attributes)

    # else
    #   # Poster.update(params[:id], poster_params)

      # render json: Poster.update(params[:id], poster_params)

    # end


    invalid_attributes = check_attributes_valid()

    binding.pry

    if invalid_attributes != []
      response.status = 418
      render json: { "message": "invalid param yo" }
    else
      if !Poster.verify_unique(params)

        binding.pry

        response.status = 418
        render json: { "message": "attempting to change name to make a duplicate yo" }
      else
      
        # binding.pry

        render json: PosterSerializer.format_single_poster(Poster.update(params[:id], poster_params()))
      end
    end
  end
  
  private
  
  def poster_params()
    params.require(:poster).permit(:name, :description, :img_url, :price, :year, :vintage)
  end

  def check_attributes_present()
    #Verify all params present; if any are not, return array of symbols for processing in serializer
    required_attributes = [:name, :description, :price, :year, :vintage, :img_url]

    required_attributes.find_all do |attribute|
      params[attribute] == nil
    end
  end

  def check_attributes_valid()
    #Verify that no required param is blank / zero; if any fail, return them as an array for processing in serializer
    attributes_to_check = [:name, :description, :price, :year, :img_url]

    attributes_to_check.find_all do |attribute|
      params[attribute] == "" || params[attribute] == 0
    end
  end
  
end
