class Poster < ApplicationRecord

  def self.sort_by_asc
    Poster.all.order(created_at: :asc)
  end

  def self.sort_by_desc
    Poster.all.order(created_at: :desc)
  end

  def self.filter_by_name(filter_text)
    filtered_posters = Poster.where("LOWER(name) LIKE '%#{filter_text.downcase}%'")
  
    filtered_posters.order(name: :asc)
  end
  
  def self.filter_by_price(price_threshold, bound)
    if bound == :min
      Poster.where("price > #{price_threshold}")
    elsif bound == :max
      Poster.where("price < #{price_threshold}")
    end
  end

  def self.verify_unique(incoming_params)
    if Poster.where(name: incoming_params[:name]) == []
      return true
    else
      return false
    end
  end
end