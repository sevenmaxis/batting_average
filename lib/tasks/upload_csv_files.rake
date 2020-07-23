# frozen_string_literal: true

require 'csv'

desc "Populate database with Teams.csv and Batting.csv"
task :upload_csv_files => :environment do
  puts "-----------------------"
  puts "Importing from Team.csv"

  teams = CSV.foreach('public/csv/Teams.csv', headers: true).with_object({}) do |row, memo|
    memo[row['teamID']] = row['name']
  end

  puts "--------------------------"
  puts "Importing from Batting.csv"
  adapter = AverageAdapter.new

  CSV.foreach('public/csv/Batting.csv', headers: true) do |row|
    row['teamID'] = teams[row['teamID']]
    adapter.insert(row)
  end

  Average.delete_all
  Average.import adapter.result
end
