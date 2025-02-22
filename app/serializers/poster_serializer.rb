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
      meta: {count: "just the one"} 
    }
  end
end