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
  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :customers, force: true do |t|
    t.string :name
    t.references :user, foreign_key: true
    t.references :customer_address, foreign_key: true
  end

  create_table :customer_addresses, force: true do |t|
    t.string :city
    t.boolean :main, default: false
    t.references :customer, foreign_key: true
    t.references :user, foreign_key: true

    t.timestamps
  end

  create_table :user_addresses, force: true do |t|
    t.string :city
    t.boolean :main, default: false
    t.references :user, foreign_key: true

    t.timestamps
  end
end

Dir[File.join(__dir__, "../../app/models/*.rb")].sort.each { |file| require file }
