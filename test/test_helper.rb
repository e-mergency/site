ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def setup
    # Empty collections other than system.indexes
    Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each {|c| c.find.remove_all}

    @simons = FactoryGirl.create(:simons)
    @kates = FactoryGirl.create(:kates)
    @peters = FactoryGirl.create(:peters)
    @kushals = FactoryGirl.create(:kushals)
    @florians = FactoryGirl.create(:florians)
  end
end
