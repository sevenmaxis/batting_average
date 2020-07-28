# frozen_string_literal: true

require "rails_helper"
require 'csv'

RSpec.describe Average, type: :model do
  let(:build_averages) { 3.times.map { build(:average) } }
  let(:averages) { 3.times.map { create(:average) } }
  let(:array_query) { "teams @> ARRAY[?]::varchar[]" }

  describe "Quering" do
    it "finds specified records" do
      average = averages.last

      record = Average.where(year: average.year).where(array_query, [average.teams.first]).first

      expect(record.year).to eq(average.year)
      expect(record.teams).to eq(average.teams)
    end
  end

  describe "Makes sure using index for" do
    let(:expeted) { "Bitmap Index Scan on index_averages_on_year_and_teams" }

    before(:each) do
      # NOTE: Force to use index for small amount of records
      ActiveRecord::Base.connection.execute("SET enable_seqscan = OFF")
    end

    it "year" do
      expect(Average.where(year: "1900").analyze).to include(expeted)
    end

    it "teams" do
      expect(Average.where(array_query, averages.last.teams).analyze).to include(expeted)
    end

    it "year and teams" do
      analyze = Average.where(year: "1891").where(array_query, averages.last.teams).analyze

      expect(analyze).to include(expeted)
    end
  end

  describe "Importing csv file" do
    it do
      adapter = AverageAdapter.new('spec/support/csv/Teams.csv')

      CSV.foreach("spec/support/csv/Batting.csv", headers: true) { |row| adapter.insert(row) }

      Average.import adapter.result

      allisar01s = Average.where(player_id: 'allisar01')

      expect(allisar01s.count).to eq(5)
      expect(allisar01s[3].average).to eq(0.23)
    end
  end

  describe "#search" do
    let(:year) { '1001' }
    let(:teams) { [Faker::Team.name, Faker::Team.name] }
    let(:average) { create(:average, year: year, teams: teams) }

    before(:each) { 10.times.each { create(:average) } }

    it 'by year' do
      result = Average.search(year: average.year)

      expect(result.count).to eq(1)
      expect(result.first.year).to eq(year)
    end

    it 'by teams' do
      result = Average.search(teams: average.teams)

      expect(result.count).to eq(1)
      expect(result.first.teams).to eq(teams)
    end

    it 'by year and teams' do
      result = Average.search(year: average.year, teams: average.teams)

      expect(result.count).to eq(1)
      expect(result.first.year).to eq(year)
      expect(result.first.teams).to eq(teams)
    end

    it 'returns result sorted by batting average' do
      batting_averages = Average.pluck(:average).sort.reverse

      averages = Average.search

      expect(averages.pluck(:average)).to eq(batting_averages)
    end
  end
end
