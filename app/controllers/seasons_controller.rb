class SeasonsController < ApplicationController
  before_action :set_series

  def show
    @season = @series.seasons.find(params[:id])
    @episodes = @season.episodes
  end

  private

  def set_series
    @series = Series.find(params[:series_id])
  end
end
