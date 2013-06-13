require 'test_helper'

class DelayTest < ActiveSupport::TestCase
  
  test "validation" do
    delay = Delay.new :minutes => 12, :hospital_id => -1
    assert !delay.valid?

    hospital = Hospital.new :name => "Test", :odscode => "DelayTestHospital", :location => [0.0, 0.0]
    assert hospital.valid?
    assert hospital.save

    delay = Delay.new :minutes => -12, :hospital => hospital 
    assert !delay.valid?

    delay = Delay.new :minutes => 0, :hospital => hospital 
    assert delay.valid?
    assert delay.save

    hospital.reload

    assert delay.hospital.id == hospital.id
    assert hospital.delays.first.id == delay.id
  end

end
