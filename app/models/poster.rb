class Poster < ApplicationRecord

  def self.sort_by_asc
    Poster.all.order(price: :asc)
  end

  def self.sort_by_desc
    Poster.all.order(price: :desc)
  end

  def self.filter_by_name(filter_text)
    #Find all records with name containing the string filter_text
    #Make text case-insensitive.  Would use SQL command LOWER(), but doesn't seem to work correctly with where(), so upcase is reasonable for now.
    filtered_posters = Poster.where("name LIKE '%#{filter_text.upcase}%'")
  
    filtered_posters.order(name: :asc)
  end
  
  def self.filter_by_price(price_threshold, bound)
    if bound == :min
      Poster.where("price > #{price_threshold}")
    elsif bound == :max
      Poster.where("price < #{price_threshold}")
    end
  end
end