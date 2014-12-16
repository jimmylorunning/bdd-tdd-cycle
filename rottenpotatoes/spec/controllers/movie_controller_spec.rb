require 'spec_helper'

describe MoviesController, :type => :controller do

	describe 'similar action' do
		context "happy path" do

			it 'should call a RESTFUL route' do
				expect(:get => '/movies/3/similar').to route_to(
					:controller => "movies",
					:action => "similar",
					:id => "3"
				)
			end

			it "should grab the id of the movie" do
				Movie.stub(:movies_with_same_director)
				Movie.stub(:find)
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

		context "sad paths" do

			it "should redirect with flash message if current movie has no director info" do
				@m1 = FactoryGirl.create(:movie, :id => 1, :title => 'Alien', :director => 'Scott')
				Movie.stub(:find).and_return(@m1)
				Movie.should_receive(:movies_with_same_director).with('1').and_return(nil)
				get :similar, {:id => '1'}
				flash.should_not be_nil
				response.should redirect_to movies_path
			end

		end

	end

	describe 'show action' do
		it "should assign movie based on param id" do
			fake_movie = double("Blade Runner")
			Movie.should_receive(:find).with('1').and_return(fake_movie)
			get :show, {:id => '1'}
			assigns(:movie).should == fake_movie
		end
	end

	describe 'index action' do
		context "sort" do

			context "params is not set" do
				it "should hilite title if sort by title specified in session" do
					session[:sort] = 'title'
					get :index
					assigns(:title_header).should == 'hilite'
					assigns(:date_header).should be_nil
				end

				it "should hilite release date if sort by date specified in session" do
					session[:sort] = 'release_date'
					get :index
					assigns(:title_header).should be_nil
					assigns(:date_header).should == 'hilite'
				end
			end

			context "params is set" do

				it "should hilite title if sort by title" do
					get :index, {:sort => 'title'}
					assigns(:title_header).should == 'hilite'
					assigns(:date_header).should be_nil
				end

				it "should hilite release date if sort by release date" do
					get :index, {:sort => 'release_date'}
					assigns(:title_header).should be_nil
					assigns(:date_header).should == 'hilite'
				end

				it "should set session sort variable to new sort value" do
					session[:sort] = 'title'
					get :index, {:sort => 'release_date'}
					session[:sort].should == 'release_date'
					get :index, {:sort => 'title'}
					session[:sort].should == 'title'
				end

				it "should redirect to index action with new sort param if session doesn't match" do
					session[:sort] = 'title'
					session[:ratings] = {'G' => 'G'}
					get :index, {:sort => 'release_date'}
					response.should redirect_to :sort => 'release_date', :ratings => {'G' => 'G'}
				end

			end

		end

		context "ratings" do

			context "params is set" do

				before {
					session[:ratings] = {'G' => 'G'}
					@par = {'R' => 'R',  'PG' =>'PG'}
					get :index, {:ratings => @par}
				}

				it "should assign ratings to params ratings" do
					assigns(:selected_ratings).should == @par
				end

				it "should set session ratings to params ratings" do
					session[:ratings].should == @par
				end

				it "should redirect to movies page with new param ratings" do
					response.should redirect_to :ratings => @par
				end

			end

			it "should assign ratings based on session if params not present" do
				session[:ratings] = {'G' => 'G'}
				get :index
				assigns(:selected_ratings).should == session[:ratings]
			end

			it "should assign ratings to all ratings if neither session nor params are present" do
				Movie.stub(:all_ratings).and_return(['G', 'PG'])
				get :index
				assigns(:selected_ratings).should == {'G' => 'G', 'PG' => 'PG'}
			end

		end

		it "should ask Movie model for all ratings and make it available to the view" do
			fake_ratings = ['R', 'PG']
			Movie.should_receive(:all_ratings).and_return(fake_ratings)
			get :index
			assigns(:all_ratings).should == fake_ratings
		end

		it "should ask Movie model for all movies" do
			fake_movies = [double("Aliens"), double("Blade Runner")]
			Movie.should_receive(:find_all_by_rating).and_return(fake_movies)
			get :index
			assigns(:movies).should == fake_movies
		end

	end

	describe "create action" do

		it "should ask Movie model to create movie" do
			fake_movie = double('Alien', :title => 'Alien')
			Movie.should_receive(:create!).and_return(fake_movie)
			post :create, {:title => 'Alien'}
		end

		context "successful" do
			before {
				fake_movie = double('Alien', :title => 'Alien')
				Movie.stub(:create!).and_return(fake_movie)
				post :create, {:title => 'Alien'}
			}

			it "should print success message" do
				flash[:notice].should_not be_nil
			end

			it "should redirect to movies page" do
				response.should redirect_to movies_path
			end
		end
	end

	describe "edit action" do
		it "should ask Movie model for movie" do
			Movie.should_receive(:find).with('1')
			get :edit, {:id => 1}
		end

		it "should make movie available to view" do
			fake_movie = double('Alien')
			Movie.stub(:find).and_return(fake_movie)
			get :edit, {:id => 1}
			assigns(:movie).should == fake_movie
		end
	end

	describe "update" do
		it "should ask Movie model for movie" do
			fake_movie = double('Alien', :update_attributes! => true, :title => 'Alien')
			Movie.should_receive(:find).with('1').and_return(fake_movie)
			put :update, {:id => 1}
		end

		it "should ask Movie model to update attributes of movie" do
			fake_movie = double('Alien', :title => 'Alien')
			Movie.stub(:find).and_return(fake_movie)
			fake_movie.should_receive(:update_attributes!).and_return(true)
			put :update, {:id => 1}
		end

		context "successful" do
			before {
				@fake_movie = double('Alien', :update_attributes! => true, :title => 'Alien')
				Movie.stub(:find).and_return(@fake_movie)
				put :update, {:id => 1}
			}

			it "should make movie available to view" do
				assigns(:movie).should == @fake_movie
			end

			it "should put up successful flash message" do
				flash.should_not be_nil
			end

			it "should redirect to movie page" do
				response.should redirect_to movie_path(@fake_movie)
			end

		end
	end

	describe "destroy" do
		it "should ask Movie model to destroy movie" do
			fake_movie = double('Alien', :title => 'Alien')
			Movie.stub(:find).and_return(fake_movie)
			fake_movie.should_receive(:destroy)
			delete :destroy, {:id => '1'}
		end

		context "afterwards" do
			before {
				fake_movie = double('Alien', :title => 'Alien', :destroy => true)
				Movie.stub(:find).and_return(fake_movie)
				delete :destroy, {:id => '1'}
			}

			it "should show flash message" do
				flash.should_not be_nil
			end

			it "should redirect to movies page" do
				response.should redirect_to movies_path
			end


		end
	end

end
