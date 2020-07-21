require 'rails_helper'
require 'csv'

RSpec.describe Team, type: :model do
  describe "Sets the TeamID as id" do
    it "imports team records from csv" do
      Team.delete_all

      CSV.foreach('spec/support/csv/Teams.csv', headers: true) do |row|
        Team.create!(id: row['teamID'], name: row['name'])
      rescue StandardError => e
        next if e.instance_of? ActiveRecord::RecordNotUnique
      end

      expect(Team.find('BS1').name).to eq('Boston Red Stockings')
      expect(Team.find('CH1').name).to eq('Chicago White Stockings')
      expect(Team.find('CL1').name).to eq('Cleveland Forest Citys')
      expect(Team.find('FW1').name).to eq('Fort Wayne Kekiongas')
    end
  end
end
