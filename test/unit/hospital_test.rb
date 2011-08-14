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

    hospital = Hospital.new :name => "Test", :longitude => 0.0, :latitude => 0.0
    assert !hospital.save # Hospital with name test already exists
  end

  test "distance" do
    simons = (Hospital.where :name => 'Simons Hospital')[0]
    kates = (Hospital.where :name => 'Kates Hospital')[0]
    peters = (Hospital.where :name => 'Peters Hospital')[0]

    dist = Hospital.distance(simons.longitude, simons.latitude, peters.longitude, peters.latitude)
    assert((dist-5000).abs<1.0)

    dist = Hospital.distance(simons.longitude, simons.latitude, kates.longitude, kates.latitude)
    assert((dist-1000).abs<10.0)

    dist = Hospital.distance(kates.longitude, kates.latitude, peters.longitude, peters.latitude)
    assert((dist-5000).abs<100.0)
  end

end
