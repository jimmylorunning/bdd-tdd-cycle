require 'spec_helper'

describe MoviesController do

	describe 'similar -- ' do
		it 'should call a RESTFUL route' do
			expect(:get => '/movies/3/similar').to route_to(
				:controller => "movies",
				:action => "similar",
				:id => "3"
			)
		end

		it "should grab the id of the movie" do
			get :similar, {:id => '1'}
			assigns(:id).should == '1'
		end

		it "should ask model for movies with same director" do
			fake_movies = [double("Blade Runner"), double("Prometheus")]
			Movie.should_receive(:movies_with_same_director).with('1').and_return(fake_movies)
			get :similar, {:id => '1'}
			assigns(:similar_movies).should == fake_movies
		end

=begin
		it "ok not sure if this is correct anymore" do
			fake_movie = double("Alien", :director => "Ridley Scott")
			Movie.should_receive(:find).with('1').and_return(fake_movie)
			get :similar, {:id => '1'}
			assigns(:director).should == "Ridley Scott"
		end
=end

	end

end
