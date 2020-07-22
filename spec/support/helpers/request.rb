# frozen_string_literal: true

module Helpers
  module Request
    def json
      JSON.parse(response.body)
    end

    def header
      response.header
    end
  end
end
