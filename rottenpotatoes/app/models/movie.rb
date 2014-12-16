class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date, :director

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.movies_with_same_director(movie_id)
  	current = self.find(movie_id)
  	self.find_all_by_director(current.director, :conditions => "id != #{current.id}")
#  	current_movie = Movie.find(movie_id)
#  	current_movie.director
  end
end

