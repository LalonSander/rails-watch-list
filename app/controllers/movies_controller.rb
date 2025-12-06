require 'open-uri'
require 'json'

class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = Movie.all.sort_by { |movie| -movie.bookmarks.count }
  end

  def show
  end

  private

  def set_movie
    @movie =  Movie.find(params[:id])
  end
end
