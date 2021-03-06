# frozen_string_literal: true

FactoryBot.define do
  factory :average do
    sequence(:player_id) { |n| "barnero#{n}" }
    sequence(:year)      { |n| "189#{n}" }
    teams   { Array.new(2) { Faker::Team.name } }
    average { rand(0.0..1.0).round(3) }
  end
end
