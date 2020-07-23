# frozen_string_literal: true

class AverageAdapter
  attr_reader :hash_table

  def initialize(csv_file_path)
    @hash_table = Hash.new { |h, k| h[k] = [] }

    @teams = CSV.foreach(csv_file_path, headers: true).with_object({}) do |row, memo|
      memo[row['teamID']] = row['name']
    end
  end

  def insert(row)
    row['teamID'] = @teams[row['teamID']]

    params = [row['playerID'], row['yearID'], row['teamID'], row['H'], row['AB']]

    hash_table[row['playerID'] + row['yearID']] << params
  end

  def result
    hash_table.each_with_object([]) do |(_, value), averages|
      attributes = { player_id: value.first[0], year: value.first[1] }

      attributes[:teams] = extract_teams(value)

      hits = extract_floats(value, 3)
      bats = extract_floats(value, 4)
      attributes[:average] = (hits / (bats.nonzero? || 1)).round(3)

      averages << Average.new(attributes)
    end
  end

  private

  def extract_teams(value)
    extract(value, 2).uniq
  end

  def extract_floats(value, index)
    extract(value, index).map(&:to_f).sum
  end

  def extract(value, index)
    value.reduce([]) { |m, r| m << r[index] }
  end
end
