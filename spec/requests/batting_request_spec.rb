# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Battings", type: :request do
  def search_request(year: nil, teams: nil)
    url = +"/search"

    query = []
    query << "year=#{year}" if year.present?
    teams.each { |team| query << "teams[]=#{team}" } if teams.present?
    query = query.join("&")

    url.concat("?", query) if query.present?

    get(url)
  end

  describe "GET #search" do
    let(:year) { '1001' }
    let(:team) { create(:team) }
    let!(:average) { create(:average, year: year, teams: [team.id]) }
    let(:attributes) { ['player_id', 'year', 'teams', 'average'] }

    before(:each) { 10.times.map { create(:average) } }

    it 'returns empty result' do
      search_request

      expect(response).to have_http_status(:success)
      expect(json.size).to eq(11)
    end

    it 'returns records with given year' do
      search_request(year: average.year)

      expect(response).to have_http_status(:success)
      expect(json).to eq([average.attributes.slice(*attributes)])
    end

    it 'returns records with given teams' do
      search_request(teams: [team.name])

      expect(response).to have_http_status(:success)
      expect(json).to eq([average.attributes.slice(*attributes)])
    end

    it 'returns records with given year and teams' do
      search_request(year: average.year, teams: [team.name])

      expect(response).to have_http_status(:success)
      expect(json).to eq([average.attributes.slice(*attributes)])
    end
  end
end
