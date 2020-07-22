# frozen_string_literal: true

class BattingController < ApplicationController
  def search
    team_ids = Team.where(name: average_params[:teams]).pluck(:id)

    averages = Average.search(year: average_params[:year], teams: team_ids)

    render json: averages.as_json(only: [:player_id, :year, :teams, :average])
  end

  private

  def average_params
    params.permit(:year, teams: [])
  end
end
