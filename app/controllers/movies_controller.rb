class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @active_ratings = params[:ratings] || session[:ratings] || {}

    if sort == 'title'
      sorting = {:order => :title}
      @title_header_active = 'active'
    elsif sort == 'release_date'
      sorting = {:order => :release_date}
      @release_date_header_active = 'active'
    end

    if params[:sort] != session[:sort]
      session[:sort] = sort
      redirect_to :sort => sort, :ratings => @active_ratings and return
    end

    if @active_ratings != {} and params[:ratings] != session[:ratings]
      session[:ratings] = @active_ratings
      redirect_to :sort => sort, :ratings => @active_ratings and return
    end
    @movies = Movie.find_all_by_rating(@active_ratings.keys, sorting)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
