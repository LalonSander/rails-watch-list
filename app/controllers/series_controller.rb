class SeriesController < ApplicationController
  def show
    @series = Series.find(params[:id])
    @seasons = @series.seasons
  end
end
