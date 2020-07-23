# frozen_string_literal: true

class Average < ApplicationRecord
  class << self
    def search(year: nil, team_ids: [])
      scope = Average.all

      scope = scope.where(year: year) if year

      if team_ids.is_a?(Array) && team_ids.present?
        scope = scope.where("teams @> ARRAY[?]::varchar[]", team_ids)
      end

      scope.order(average: :desc)
    end
  end
end
