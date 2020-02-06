#https://medium.com/@nbanzyme/how-to-install-heroku-on-an-aws-cloud-9-environment-5ff3d4e14c73
class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #https://www.rubydoc.info/docs/rails/4.1.7/ActiveRecord%2FQueryMethods:order
  #https://stackoverflow.com/questions/2989762/multi-line-comments-in-ruby
  #https://apidock.com/rails/ActiveRecord/QueryMethods/order
  def index
    @all_ratings = Movie.list_ratings
    if(params["ordering"] == nil && params["ratings"] == nil)
      if(session["ordering"] == nil)
        session["ordering"] = "none"
      end
      if(session["ratings"] == nil)
        session["ratings"] = {"G"=>1, "PG"=>1, "PG-13"=>1, "R"=>1}
      end
      redirect_to movies_path(:ordering => session["ordering"], :ratings => session["ratings"])
    elsif(params["ordering"] == nil)
      if(session["ordering"] == nil)
        session["ordering"] = "none"
      end
      redirect_to movies_path(:ordering => session["ordering"], :ratings => params["ratings"])
    elsif(params["ratings"] == nil)
      if(session["ratings"] == nil)
        session["ratings"] = {"G"=>1, "PG"=>1, "PG-13"=>1, "R"=>1}
      end
      redirect_to movies_path(:ordering => params["ordering"], :ratings => session["ratings"])
    else
      session["ordering"] = params["ordering"]
      session["ratings"] = params["ratings"]
      if(params["ordering"] == 'title')
        @titleSorted = true
        @releaseDateSorted = false
        ratingsKeys = params["ratings"].keys
        @movies = Movie.where(rating: ratingsKeys).order("title")
      elsif(params["ordering"] == 'release_date')
        @titleSorted = false
        @releaseDateSorted = true
        ratingsKeys = params["ratings"].keys
        @movies = Movie.where(rating: ratingsKeys).order("release_date")
      else
        @titleSorted = false
        @releaseDateSorted = false
        ratingsKeys = params["ratings"].keys
        @movies = Movie.where(rating: ratingsKeys)
      end
    end

    
=begin
    else
      if(params["ratings"] == nil)
        @movies = Movie.all
      else
        ratingKeys = params["ratings"].keys
        @movies = Movie.where(rating: ratingKeys)
      end
      @releaseDateSorted=false
      @titleSorted=false
    end
=end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
