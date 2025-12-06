class EpisodesController < ApplicationController
  before_action :set_series
  before_action :set_season

  def show
    @episode = @season.episodes.find(params[:id])
  end

  private

  def set_series
    @series = Series.find(params[:series_id])
  end

  def set_season
    @season = @series.seasons.find(params[:season_id])
  end
end
