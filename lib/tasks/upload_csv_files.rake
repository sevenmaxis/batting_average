# frozen_string_literal: true

require 'csv'

desc "Populate database with Teams.csv and Batting.csv"
task :upload_csv_files => :environment do
  puts "-----------------------"
  puts "Importing from Team.csv"
  teams = []

  CSV.foreach('public/csv/Teams.csv', headers: true) do |row|
    teams << Team.new(id: row['teamID'], name: row['name'])
  end
  Team.delete_all
  Team.import teams, on_duplicate_key_ignore: true

  puts "--------------------------"
  puts "Importing from Batting.csv"
  puts "It will take about 2 minutes"
  adapter = AverageAdapter.new

  CSV.foreach('public/csv/Batting.csv', headers: true) { |row| adapter.insert(row) }

  Average.delete_all
  Average.import adapter.result
end
