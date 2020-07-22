# frozen_string_literal: true

class BattingController < ApplicationController
  def search
    averages = Average.search(year: average_params[:year], teams: average_params[:teams])

    render json: averages.as_json(only: [:player_id, :year, :teams, :average])
  end

  private

  def average_params
    params.permit(:year, teams: [])
  end
end
