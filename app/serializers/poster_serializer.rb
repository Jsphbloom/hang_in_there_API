class PosterSerializer
  def self.format_posters(posters)
    poster_data = posters.map do |poster|
      {
        #id, type, attributes, name, description, year, price, vintage, url
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

    return { data: poster_data }
  end

  def self.format_created_poster()
    
  end

end