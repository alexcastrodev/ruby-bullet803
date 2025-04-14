require_relative "test_helper"
require "bullet"
require "logger"

class BulletTest < Minitest::Test
  def setup
    # Enable ActiveRecord logging to STDOUT for debugging purposes
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    # Clear any existing records
    User.delete_all
    Customer.delete_all
    CustomerAddress.delete_all

    # Create user
    @user = User.create!(name: "Test User")

    # Configure Bullet to detect and raise on N+1 queries
    Bullet.enable = true
    Bullet.raise = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
    
    # Start Bullet request tracking
    Bullet.start_request
  end

  def teardown
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end

  def test_creating_multiple_main_addresses
    # Create a customer with multiple main addresses
    # This should trigger Bullet to detect an N+1 query
    # and raise an error if Bullet.raise is set to true
    create_params = {
      name: "Test Customer",
      addresses_attributes: [
      { city: "City 1", main: true },
      { city: "City 2", main: true },
      ],
    }
    customer = @user.customers.build(create_params)
    
    customer.save!
  end
end
