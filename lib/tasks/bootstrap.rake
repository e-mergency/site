require 'json'

namespace :bootstrap do

  desc "Creates the roles"
  task :create_roles => :environment do
    %w[guest hospital admin].map do |name|
      Role.find_or_create_by(name: name)
    end
  end

  desc "Creates the admin users"
  task :admin_users => :environment do
    %w[ simon.funke florian.rathgeber kushi.p peterejhamilton].map do |name|
      begin
        user = User.new email:                 "#{ name }@gmail.com",
                        password:              'password',
                        password_confirmation: 'password'

        user.save
      rescue ActionView::Template::Error
        puts "There was a problem creating #{ name }!"
      end
      user.save
      # user.confirm!
      # Change the role to a admin role
      user.roles=[Role.find_by(name: 'admin')]
      user.save
    end
  end

  desc "Imports hospitals from NHS Choices"
  task :import_hospitals => :environment do
    json = JSON.parse(File.read('lib/locations.json'))
    json.each do |j|
      j = j.second
      Hospital.create( {
        'source_uri' => j['apiurl'],
        'name'       => j['name'],
        'updated'    => j['updated'],
        'odscode'    => j['odscode'],
        'postcode'   => j['postcode'],
        'location'   => [ j['coordinates']['longitude'].to_f, j['coordinates']['latitude'].to_f ]
      } )
    end
  end

  desc "Run all bootstrapping tasks"
  task :all => [:create_roles, :admin_users, :import_hospitals]

end
