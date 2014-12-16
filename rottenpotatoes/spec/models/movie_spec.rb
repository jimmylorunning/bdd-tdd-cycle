require 'spec_helper'

describe Movie do

	describe 'movies_with_same_director' do
		context "id not found" do
			it "should raise error if movie with that id is not found" do
				# how to test this?
	#			Movie.movies_with_same_director(5).should raise_error ActiveRecord::RecordNotFound
			end
		end

		context "movie found" do

			before :each do
				@m1 = FactoryGirl.create(:movie, :id => 1, :title => 'One', :director => 'Lucas')
				@m2 = FactoryGirl.create(:movie, :id => 2, :title => 'Two', :director => 'Lucas')
				@m3 = FactoryGirl.create(:movie, :id => 3, :title => 'Three', :director => 'Scott')
				@m4 = FactoryGirl.create(:movie, :id => 4, :title => 'Four', :director => 'Scott')
				@m5 = FactoryGirl.create(:movie, :id => 5, :title => 'Five', :director => 'Lucas')
				@m6 = FactoryGirl.create(:movie, :id => 6, :title => 'Six', :director => 'Kiarostami')
				@m7 = FactoryGirl.create(:movie, :id => 7, :title => 'Seven')
			end

			it "should return empty array if no other movies in the db have the same director" do
				Movie.movies_with_same_director(@m6.id).should == []
			end

			it "should return collection of movies with the same director" do
				Movie.movies_with_same_director(@m1.id).should == [@m2, @m5]
			end

			it "should return nil if current movie has no director information" do
				Movie.movies_with_same_director(@m7.id).should == nil
			end

		end

	end

end