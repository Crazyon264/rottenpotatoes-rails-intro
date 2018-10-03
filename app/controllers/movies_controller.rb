class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
  
   #is there a new session
  if session[:sort] != true
    session[:sort] = true
    session[:selected_ratings] = @all_ratings
  end
  
  
  if params[:sort] != nil
     session[:sort] = params[:sort]
  elsif session[:sort] != nil
    redirect_to :rating => params[:rating], :sort => session[:sort] and return
  end
  
  
  
    #If the params not nil, set the session to those params
    if params[:rating] != nil
     session[:selected_ratings] = params[:ratings]
    elsif params[:rating] == nil and session[:selected_ratings] == nil
     session[:selected_ratings] = @all_ratings
     
  
    if params[:rating] != nil
      session[:selected_ratings] = params[:rating]
    elsif params[:rating] == nil and session[:selected_ratings] == nil
      session[:selected_ratings] = @all_ratings
      flash.keep
      redirect_to movies_path :sort => @sort_choice, :ratings => @selected_ratings
    end
  
    @selected_ratings = session[:selected_ratings]
    @sort = session[:sort]
  
  
    case @sort 
    when 'title'
      @movies = Movie.where(:rating => @selected_ratings.keys).order(:title)
      @title_head = 'hilite'
    when 'release_date' 
      @movies = Movie.where(:rating => @selected_ratings.keys).order(:release_date)
      @release_head = 'hilite'
    else
      @movies = Movie.all
    end
    
    end 
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

