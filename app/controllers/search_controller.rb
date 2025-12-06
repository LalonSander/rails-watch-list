require "open-uri"

class SearchController < ApplicationController
  def search
    @list = List.find(params[:list_id])
    @query = params[:query].to_s.strip
    type = params[:type].presence || "movie"   # "movie" or "tv"

    # Select the correct model based on type
    model = type == "movie" ? Movie : Series

    # Check local DB first
    @item = model.where("LOWER(title) = ?", @query.downcase).first

    unless @item
      # Build TMDB URL dynamically
      api_url = "https://tmdb.lewagon.com/search/#{type}?query=#{URI.encode_www_form_component(@query)}"

      data = JSON.parse(URI.open(api_url).read)
      first_result = data["results"].first

      if first_result
        @item = model.new(
          title: first_result["title"] || first_result["name"] || "Untitled",
          overview: first_result["overview"] || "",
          poster_url: first_result["poster_path"] ? "https://image.tmdb.org/t/p/w500#{first_result['poster_path']}" : "https://placehold.co/300x450?text=No+Poster",
          rating: first_result["vote_average"] || 0.0,
          tmdb_id: first_result["id"] || 0
        )

        unless @item.save
          @item = model.find_by(title: @item.title)
        end

        # If it's a TV series, fetch seasons and episodes
        if type == "tv"
          tvapi_url = "https://tmdb.lewagon.com/tv/#{@item.tmdb_id}"
          tv_data = JSON.parse(URI.open(tvapi_url).read)
          number_of_seasons = tv_data['number_of_seasons']
          fetch_tv_details(@item, number_of_seasons)
        end
      end
    end

    render "lists/show"
  end

  private

  def fetch_tv_details(series, number_of_seasons)
    (1..number_of_seasons).each do |season_number|
      # Find or create season
      season = series.seasons.find_or_initialize_by(season_number: season_number)
      season.title = "#{series.title} Season #{season_number}" if season.new_record?
      season.save!

      # Fetch episodes for this season
      season_url = "https://tmdb.lewagon.com/tv/#{series.tmdb_id}/season/#{season_number}"
      season_data = JSON.parse(URI.open(season_url).read)
      episodes_data = season_data["episodes"] || []

      episodes_data.each do |ep_data|
        episode = season.episodes.find_or_initialize_by(episode_number: ep_data["episode_number"])
        episode.title = ep_data["name"] || "Episode #{ep_data['episode_number']}"
        episode.overview = ep_data["overview"] || ""
        episode.still_url = ep_data["still_path"] ? "https://image.tmdb.org/t/p/w500#{ep_data['still_path']}" : "https://placehold.co/300x169?text=No+Still"
        episode.rating = ep_data["vote_average"] || 0.0
        episode.save!
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch TV details for #{series.title}: #{e.message}")
  end
end
