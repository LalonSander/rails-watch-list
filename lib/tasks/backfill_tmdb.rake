require 'open-uri'
require 'json'

namespace :movies do
  desc "Backfill tmdb_id for all movies"
  task backfill_tmdb_id: :environment do
    Movie.find_each do |movie|
      begin
        api_url = "https://tmdb.lewagon.com/search/movie?query=#{URI.encode_www_form_component(movie.title)}"
        data = JSON.parse(URI.open(api_url).read)
        first_result = data['results'].first
        tmdb_id = first_result['id'] if first_result

        if tmdb_id
          movie.update!(tmdb_id: tmdb_id)
          puts "Updated #{movie.title} → #{tmdb_id}"
        else
          puts "No result for #{movie.title}"
        end
      rescue => e
        puts "Failed for #{movie.title}: #{e.message}"
      end
    end
  end
end
