# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe Team, type: :model do
  let(:csv_file) { 'spec/support/csv/Teams.csv' }

  before(:each) { Team.delete_all }

  describe "Sets the TeamID as id" do
    it "imports team records from csv" do
      CSV.foreach(csv_file, headers: true) do |row|
        Team.create!(id: row['teamID'], name: row['name'])
      rescue StandardError => e
        next if e.instance_of? ActiveRecord::RecordNotUnique
      end

      expect(Team.find('BS1').name).to eq('Boston Red Stockings')
      expect(Team.find('CH1').name).to eq('Chicago White Stockings')
      expect(Team.find('CL1').name).to eq('Cleveland Forest Citys')
      expect(Team.find('FW1').name).to eq('Fort Wayne Kekiongas')
      expect(Team.find('BL1').name).to eq('Baltimore Canaries')
    end
  end

  describe "Imports teams by activerecord-import" do
    it "imports csv into Team" do
      teams = []

      CSV.foreach(csv_file, headers: true) do |row|
        teams << Team.new(id: row['teamID'], name: row['name'])
      end

      Team.import teams, on_duplicate_key_ignore: true

      expect(Team.find('BS1').name).to eq('Boston Red Stockings')
      expect(Team.find('CH1').name).to eq('Chicago White Stockings')
      expect(Team.find('CL1').name).to eq('Cleveland Forest Citys')
      expect(Team.find('FW1').name).to eq('Fort Wayne Kekiongas')
      expect(Team.find('BL1').name).to eq('Baltimore Canaries')
    end
  end

  describe "Using index" do
    it 'makes sure using index' do
      explain = Team.where(id: 'BL1').explain

      expect(explain).to include('Index Scan using teams_pkey on teams')
    end
  end
end
