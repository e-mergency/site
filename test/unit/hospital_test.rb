require 'test_helper'

class HospitalTest < ActiveSupport::TestCase
  test "validation" do
    hospital = Hospital.new 
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :location => [0.0, -91.0]
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :location => [0.0, 91.0]
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :location => [181.0, 0.0]
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :location => [181.0, 0.0]
    assert !hospital.valid?

    hospital = Hospital.new :name => "Test", :odscode => "FOO123", :location => [18.0, 90.0]
    assert hospital.valid?
    assert hospital.save

    hospital = Hospital.new :name => "Test", :odscode => "FOO123", :location => [0.0, 0.0]
    assert !hospital.save # Hospital with that odscode already exists
  end

  test "distance" do
    dist = Hospital.compute_distance(@simons.latitude, @simons.longitude, @peters.latitude, @peters.longitude)
    assert((dist-5000).abs<1.0)

    dist = @simons.compute_distance(@peters.latitude, @peters.longitude)
    assert((dist-5000).abs<1.0)

    dist = Hospital.compute_distance(@simons.latitude, @simons.longitude, @kates.latitude, @kates.longitude)
    assert((dist-1000).abs<10.0)

    dist = Hospital.compute_distance(@simons.latitude, @simons.longitude, @florians.latitude, @florians.longitude)
    assert((dist-5000).abs<20.0)

    dist = Hospital.compute_distance(@simons.latitude, @simons.longitude, @kates.latitude, @kates.longitude)
    assert((dist-1000).abs<10.0)

    dist = Hospital.compute_distance(@peters.latitude, @peters.longitude, @florians.latitude, @florians.longitude)
    assert((dist-Math.sqrt(5000**2+5000**2)).abs<15.0)

    dist = Hospital.compute_distance(@kushals.latitude, @kushals.longitude, @florians.latitude, @florians.longitude)
    assert((dist-Math.sqrt(5000**2+10000**2)).abs<5.0)

    dist = Hospital.compute_distance(@kates.latitude, @kates.longitude, @florians.latitude, @florians.longitude)
    assert((dist-6000).abs<25.0)

    lon = @simons.longitude + 0.5*(@florians.longitude-@simons.longitude)
    lat = @simons.latitude + 0.5*(@peters.latitude-@simons.latitude)

    dist = @florians.compute_distance(lat, lon)
    assert((dist-(Math.sqrt(5000**2+5000**2)/2)).abs<10)

    dist = @peters.compute_distance(lat, lon)
    assert((dist-(Math.sqrt(5000**2+5000**2)/2)).abs<10)
  end

  test "find_hospital_near" do
    assert Hospital.find_hospitals_near_latlon(0, 0, 10).length == 0

    # Check that the correct hospitals in the bounding box are found
    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 10)
    assert results.length == 5
    assert  results.include?(@simons) and  results.include?(@kates) and results.include?(@peters) and results.include?(@kushals) and results.include?(@florians)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 9.9)
    assert results.length == 4
    assert  results.include?(@simons) and  results.include?(@kates) and results.include?(@peters) and results.include?(@florians)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 5)
    assert results.length == 4
    assert  results.include?(@simons) and  results.include?(@kates) and results.include?(@peters) and results.include?(@florians)
    
    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 4.9)
    assert results.length == 2
    assert  results.include?(@simons) and  results.include?(@kates)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 1)
    assert results.length == 2
    assert  results.include?(@simons) and  results.include?(@kates)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 0.9)
    assert results.length == 1
    assert  results.include?(@simons)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 0.1)
    assert results.length == 1
    assert  results.include?(@simons)

    results = Hospital.find_hospitals_near_latlon(@simons.latitude, @simons.longitude, 0)
    assert results.length == 1
    assert  results.include?(@simons)
    
    # Now check that hospitals in the bounding box but distance larger than of interest are removed
    lon = @simons.longitude + 0.5*(@florians.longitude-@simons.longitude)
    lat = @simons.latitude + 0.5*(@peters.latitude-@simons.latitude)
    
    results = Hospital.find_hospitals_near_latlon(lat, lon, Math.sqrt(5**2+5**2)/2-0.1)
    assert results.size == 0

    results = Hospital.find_hospitals_near_latlon(lat, lon, Math.sqrt(5**2+5**2)/2)
    assert results.length == 3
    assert  results.include?(@simons) and  results.include?(@florians) and results.include?(@peters)

    results = Hospital.find_hospitals_near_latlon(lat, lon, 5.5)
    assert results.length == 4
    assert  results.include?(@simons) and  results.include?(@florians) and results.include?(@peters) and results.include?(@kates)
  end
end
