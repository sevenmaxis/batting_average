# frozen_string_literal: true

require 'csv'

desc "Populate database with Teams.csv and Batting.csv"
task :upload_csv_files => :environment do
  puts "--------------------------"
  puts "Importing from Batting.csv"

  adapter = AverageAdapter.new('public/csv/Teams.csv')

  CSV.foreach('public/csv/Batting.csv', headers: true) { |row| adapter.insert(row) }

  Average.delete_all
  Average.import adapter.result
end
