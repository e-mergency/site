require 'json'

namespace :test_data do

  desc "Creates delay time test data"
  task :delay_time=> :environment do
    Hospital.all.each do |hospital|
      if hospital.id%10==1
        for i in 0..8
          delay = Delay.new(:hospital => hospital)
          # Change the creation of the delay object to be i days in the past
          delay.created_at = delay.created_at - i.days
          delay.updated_at = delay.created_at
          delay.minutes = Math.sin((i+hospital.id).to_f)*100+100
          delay.save
        end
      end
    end
  end

  desc "Run all test data tasks"
  task :all => [:delay_time]
end
