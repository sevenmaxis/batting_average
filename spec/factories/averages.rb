FactoryBot.define do
  factory :average do
    sequence(:id) { |n| "PS#{n}" }
    sequence(:year) { |n| "189#{n}" }
    teams { Array.new(2) { Faker::Team.name } }
    average { rand(0.0..1.0).round(3) }
  end
end
