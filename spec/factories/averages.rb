# frozen_string_literal: true

FactoryBot.define do
  factory :average do
    sequence(:player_id) { |n| "barnero#{n}" }
    sequence(:year)      { |n| "189#{n}" }
    sequence(:teams)     { |n| ["RS#{n}", "GS#{n}"] }
    average { rand(0.0..1.0).round(3) }
  end
end
