# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:id) { |n| "PS#{n}" }
    name { Faker::Team.name }
  end
end
