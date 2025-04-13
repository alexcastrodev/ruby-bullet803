require_relative "test_helper"
require "bullet"
require "logger"

class BulletTest < Minitest::Test
  def setup
    # Configure Bullet to detect and raise on N+1 queries
    Bullet.enable = true
    Bullet.raise = true

    # Enable ActiveRecord logging to STDOUT for debugging purposes
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    # Clear any existing records
    Workshop.delete_all
    InventoryItem.delete_all
    Car.delete_all

    # Create 5 Car records for association
    @cars = 5.times.map do |i|
      Car.create!(name: "Test Car #{i + 1}")
    end

    # Start Bullet request tracking
    Bullet.start_request
  end

  def teardown
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end

  def test_creating_workshop_with_five_cars
    # Build a Workshop using nested attributes for multiple inventory_items.
    # Each inventory_item will reference one of the 5 created cars.
    workshop = Workshop.new(
      name: "Test Workshop",
      inventory_items_attributes: @cars.map do |car|
        { car_id: car.id, quantity: rand(1..5) }
      end
    )
    
    # Save the workshop along with its associated inventory_items
    workshop.save!
    
    # Use eager loading to ensure all associated records are loaded efficiently
    loaded_workshop = Workshop.includes(inventory_items: :car).find(workshop.id)
    
    # Verify that exactly 5 inventory_items are associated with the workshop
    assert_equal 5, loaded_workshop.inventory_items.count
    
    # Optionally verify that each inventory item references the correct Car record
    loaded_workshop.inventory_items.each_with_index do |inventory_item, index|
      expected_car_name = "Test Car #{index + 1}"
      assert_equal expected_car_name, inventory_item.car.name
    end
  end
end
