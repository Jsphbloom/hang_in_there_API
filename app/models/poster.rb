class Poster < ApplicationRecord

  def self.sort_by_asc
    Poster.all.order(price: :asc)
  end

  def self.sort_by_desc
    Poster.all.order(price: :desc)
  end
end