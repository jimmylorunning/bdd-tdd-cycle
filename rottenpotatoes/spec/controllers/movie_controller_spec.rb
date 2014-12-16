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
			Movie.stub(:movies_with_same_director)
			get :similar, {:id => '1'}
			assigns(:id).should == '1'
		end

		it "should ask model for movies with same director" do
			fake_movies = [double("Blade Runner"), double("Prometheus")]
			Movie.should_receive(:movies_with_same_director).with('1').and_return(fake_movies)
			get :similar, {:id => '1'}
			assigns(:movies).should == fake_movies
		end

	end

end
