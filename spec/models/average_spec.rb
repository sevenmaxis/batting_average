require "rails_helper"
require 'csv'

RSpec.describe Average, type: :model do
  let(:build_averages) { 3.times.map { build(:average) } }
  let(:averages) { 3.times.map { create(:average) } }

  describe "Quering" do
    it "finds specified records" do
      average = averages.last

      record = Average.where(year: average.year).where("teams @> ARRAY[?]::varchar[]", [average.teams.first]).first

      expect(record.year).to eq(average.year)
      expect(record.teams).to eq(average.teams)
    end
  end

  describe "Using indexs" do
    before(:each) do
      # NOTE: Force to use index for small amount of records
      ActiveRecord::Base.connection.execute("SET enable_seqscan = OFF")
    end

    it "makes sure using index for year" do
      analyze = Average.where(year: "1900").analyze

      expect(analyze).to include("Bitmap Index Scan on index_averages_on_year_and_teams")
    end

    it "makes sure using index for teams" do
      analyze = Average.where("teams @> ARRAY[?]::varchar[]", averages.last.teams).analyze

      expect(analyze).to include("Bitmap Index Scan on index_averages_on_year_and_teams")
    end

    it "makes sure using index for year and teams" do
      analyze = Average.where(year: "1891").where("teams @> ARRAY[?]::varchar[]", averages.last.teams).analyze

      expect(analyze).to include("Bitmap Index Scan on index_averages_on_year_and_teams")
    end
  end

  describe "Importing csv file" do
    it 'imports csv file into Average' do
      adapter = AverageAdapter.new

      CSV.foreach("spec/support/csv/Batting.csv", headers: true) { |row| adapter.insert(row) }

      Average.import adapter.result

      allisar01s = Average.where(player_id: 'allisar01')

      expect(allisar01s.count).to eq(5)
      expect(allisar01s[3].average).to eq(0.23)
    end
  end
end
