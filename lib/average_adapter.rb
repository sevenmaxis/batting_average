class AverageAdapter
  attr_reader :hash_table

  def initialize
    @hash_table = Hash.new { |h, k| h[k] = [] }
  end

  def insert(row)
    params = [row['playerID'], row['yearID'], row['teamID'], row['H'], row['AB']]

    hash_table[row['playerID'] + row['yearID']] << params
  end

  def result
    hash_table.each_with_object([]) do |(_, value), averages|
      attributes = { player_id: value.first[0], year: value.first[1] }

      attributes[:teams] = value.reduce([]) { |m, r| m << r[2] }.uniq

      hits = value.reduce([]) { |m, r| m << r[3] }.map(&:to_f).sum
      bats = value.reduce([]) { |m, r| m << r[4] }.map(&:to_f).sum
      attributes[:average] = (hits / (bats.nonzero? || 1)).round(3)

      averages << Average.new(attributes)
    end
  end
end
