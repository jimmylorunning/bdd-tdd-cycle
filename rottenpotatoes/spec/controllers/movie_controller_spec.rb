require 'spec_helper'

describe MoviesController do

	describe 'Add Director' do

		before :each do
			@movie = mock(Movie, :id => 1, :title => 'Alien', :director => 'Jimmy')
			Movie.stub!(:find).with("1").and_return(@movie)
		end

		it 'should call update_attributes' do
			#params = {:id => 1, :director => 'Isabella'}
			#@movie.should_receive(:update_attributes!).with(params).and_return(true)
			#@movie.stub!(:update_attributes!).and_return(true)

			#put :update, {params}
		end
	end
end
