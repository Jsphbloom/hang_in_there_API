class PosterSerializer
  def self.format_posters(posters)
    poster_data = posters.map do |poster|
      {
        id: poster.id,
        type: "poster",
        attributes: {
          name: poster.name,
          description: poster.description,
          price: poster.price,
          year: poster.year,
          vintage: poster.vintage,
          img_url: poster.img_url
        }
      }
    end

    return { 
      data: poster_data,
      meta: {count: poster_data.count}
    }
  end

  def self.format_single_poster(poster)
    poster_data = {
      id: poster.id,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
      }
    }
    return {
      data: poster_data,
      meta: { count: poster_data.count }
    }
  end

  def self.return_error()
    {
      "errors": [
        {
          "status": "404",
          "message": "Record not found"
        }
      ]
    }
  end

  def self.return_missing_attrs_error(missing_attrs)
    {
      "errors": [
        {
          "status": "422",
          "message": "#{PosterSerializer.build_error_params_text(missing_attrs)} cannot be blank."
        }
      ]
    }
  end

  def self.return_invalid_attrs_error(invalid_attrs)
    {
      "errors": [
        {
          "status": "422",
          "message": "#{PosterSerializer.build_error_params_text(invalid_attrs)} cannot be an empty string or zero."
        }
      ]
    }
  end

  def self.return_duplicate_error()
    {
      "errors": [
        {
          "status": "418",
          "message": "Attempting to create / update a duplicate entry.  Please use a unique name."
        }
      ]
    }
  end

  private

  def self.build_error_params_text(attributes)
    attributes.reduce("") do |message_text, attribute|
      message_text += "#{attribute.to_s.capitalize} and "
    end.delete_suffix(" and ")
  end

end