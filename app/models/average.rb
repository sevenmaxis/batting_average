# frozen_string_literal: true

class Average < ApplicationRecord
  class << self
    def search(year: nil, teams: [])
      scope = Average.all

      scope = scope.where(year: year) if year

      if teams.is_a?(Array) && teams.present?
        scope = scope.where("teams @> ARRAY[?]::varchar[]", teams)
      end

      scope
    end
  end
end
