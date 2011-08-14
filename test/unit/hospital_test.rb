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
    kushals = (Hospital.where :name => 'Kushals Hospital')[0]
    florians = (Hospital.where :name => 'Florians Hospital')[0]

    dist = Hospital.distance(simons.latitude, simons.longitude, peters.latitude, peters.longitude)
    assert((dist-5000).abs<1.0)

    dist = simons.distance(peters.latitude, peters.longitude)
    assert((dist-5000).abs<1.0)

    dist = Hospital.distance(simons.latitude, simons.longitude, kates.latitude, kates.longitude)
    assert((dist-1000).abs<10.0)

    dist = Hospital.distance(simons.latitude, simons.longitude, florians.latitude, florians.longitude)
    assert((dist-5000).abs<20.0)

    dist = Hospital.distance(simons.latitude, simons.longitude, kates.latitude, kates.longitude)
    assert((dist-1000).abs<10.0)

    dist = Hospital.distance(peters.latitude, peters.longitude, florians.latitude, florians.longitude)
    assert((dist-Math.sqrt(5000**2+5000**2)).abs<15.0)

    dist = Hospital.distance(kushals.latitude, kushals.longitude, florians.latitude, florians.longitude)
    assert((dist-Math.sqrt(5000**2+10000**2)).abs<5.0)

    dist = Hospital.distance(kates.latitude, kates.longitude, florians.latitude, florians.longitude)
    assert((dist-6000).abs<25.0)
  end

  test "find_hospital_near" do
    assert Hospital.find_hospitals_near_latlon(0, 0, 10).count == 0

    simons = (Hospital.where :name => 'Simons Hospital')[0]
    kates = (Hospital.where :name => 'Kates Hospital')[0]
    peters = (Hospital.where :name => 'Peters Hospital')[0]
    kushals = (Hospital.where :name => 'Kushals Hospital')[0]
    florians = (Hospital.where :name => 'Florians Hospital')[0]

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 10000)
    assert results.count == 5
    assert  results.include?(simons) and  results.include?(kates) and results.include?(peters) and results.include?(kushals) and results.include?(florians)

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 9900)
    assert results.count == 4
    assert  results.include?(simons) and  results.include?(kates) and results.include?(peters) and results.include?(florians)

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 5000)
    assert results.count == 4
    assert  results.include?(simons) and  results.include?(kates) and results.include?(peters) and results.include?(florians)
    
    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 4900)
    assert results.count == 2
    assert  results.include?(simons) and  results.include?(kates)

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 1000)
    assert results.count == 2
    assert  results.include?(simons) and  results.include?(kates)

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 900)
    assert results.count == 1
    assert  results.include?(simons) 

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 1)
    assert results.count == 1
    assert  results.include?(simons) 

    results = Hospital.find_hospitals_near_latlon(simons.latitude, simons.longitude, 0)
    assert results.count == 1
    assert  results.include?(simons) 
  end
end
