require 'csv'

desc "Populate database with Teams.csv and Batting.csv"
task :upload_csv_files => :environment do
  puts "-----------------------"
  puts "Importing from Team.csv"
  teams = []
  Team.delete_all

  CSV.foreach('public/csv/Teams.csv', headers: true) do |row|
    teams << Team.new(id: row['teamID'], name: row['name'])
  end
  Team.import teams, on_duplicate_key_ignore: true

  puts "--------------------------"
  puts "Importing from Batting.csv"
  adapter = AverageAdapter.new
  Average.delete_all

  CSV.foreach('public/csv/Batting.csv', headers: true) { |row| adapter.insert(row) }

  Average.import adapter.result
end
