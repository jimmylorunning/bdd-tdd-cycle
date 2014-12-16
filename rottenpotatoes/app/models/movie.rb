class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date, :director

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.movies_with_same_director(movie_id)
  	current = self.find(movie_id)
  	return nil if (current.director.nil? || current.director.empty?)
  	self.find_all_by_director(current.director, :conditions => "id != #{current.id}")
  end
end

