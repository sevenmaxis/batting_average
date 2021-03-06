# frozen_string_literal: true

class BattingController < ApplicationController
  def search
    averages = Average.search(year: year, teams: teams)

    render json: averages.as_json(only: [:player_id, :year, :teams, :average])
  end

  private

  def average_params
    params.permit(:year, teams: [])
  end

  def teams
    average_params[:teams]
  end

  def year
    average_params[:year]
  end
end
