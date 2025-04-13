require "bundler/setup"
require "active_record"
require "sqlite3"
require "minitest/autorun"

# Establish an in-memory SQLite3 connection
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

# Define the database schema
ActiveRecord::Schema.define do
  create_table :workshops, force: true do |t|
    t.string :name
  end

  create_table :cars, force: true do |t|
    t.string :name
  end

  create_table :inventory_items, force: true do |t|
    t.integer :quantity, default: 0, null: false
    t.integer :workshop_id
    t.integer :car_id
  end
end

# Load models from app/models using __dir__
Dir[File.join(__dir__, "../app/models/*.rb")].sort.each { |file| require file }
