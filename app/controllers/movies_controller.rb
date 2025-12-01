require 'open-uri'
require 'json'

class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = Movie.all.sort_by { |movie| -movie.bookmarks.count }
  end

  def show
  end

  def search
    @list = List.find(params[:list_id])
    @query = params[:query].to_s.strip

    @movie = Movie.where("LOWER(title) = ?", @query.downcase).first

    if !@movie
      api_url = "https://tmdb.lewagon.com/search/movie?query=#{URI.encode_www_form_component(@query)}"

      data = JSON.parse(URI.open(api_url).read)
      first_result = data['results'].first

      if first_result
        @movie = Movie.new(
          title: first_result['title'] || "Untitled",
          overview: first_result['overview'] || "",
          poster_url: first_result['poster_path'] ? "https://image.tmdb.org/t/p/w500#{first_result['poster_path']}" : "https://placehold.co/300x450?text=No+Poster",
          rating: first_result['vote_average'] || 0.0,
          tmdb_id: first_result['id'] || 0
        )

        if @movie.save
          Rails.logger.debug("Movie saved: #{@movie.title}")
        else
          @movie = Movie.find_by(title: @movie.title)
        end
      end

    end

    render "lists/show"
  end

  private

  def set_movie
    @movie =  Movie.find(params[:id])
  end
end
