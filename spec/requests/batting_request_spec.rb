# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Battings", type: :request do
  def search_request(year: nil, teams: nil)
    url = "/search"

    query = []
    query << "year=#{year}" if year.present?
    query << "teams=#{teams}" if teams.present?
    query = query.join("&")

    if query.present?
      url << "?"
      url << query
    end

    get(url)
  end

  describe "GET #search" do
    it 'returns empty result' do
      search_request

      expect(response).to have_http_status(:success)
      expect(json).to be_empty
    end
  end
=begin
  describe "GET #index" do
    before do
      get :index
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "JSON body response contains expected recipe attributes" do
      json_response = JSON.parse(response.body)
      expect(hash_body.keys).to match_array([:id, :ingredients, :instructions])
    end
  end

  it "creates a Widget and redirects to the Widget's page" do
    get "/widgets/new"
    expect(response).to render_template(:new)

    post "/widgets", :params => { :widget => {:name => "My Widget"} }

    expect(response).to redirect_to(assigns(:widget))
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.body).to include("Widget was successfully created.")
  end

  it "does not render a different template" do
    get "/widgets/new"
    expect(response).to_not render_template(:show)
  end
=end
end
