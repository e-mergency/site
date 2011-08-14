require 'test_helper'

class HospitalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "validation" do
    hospital = Hospital.new 
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :longitude => 0.0, :latitude => -91.0
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :longitude => 0.0, :latitude => 91.0
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :longitude => 181.0, :latitude => 0.0
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :longitude => 181.0, :latitude => 0.0
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :longitude => 18.0, :latitude => 90.0
    assert hospital.valid?
    assert hospital.save
  end
end
