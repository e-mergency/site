namespace :bootstrap do

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
      user.roles=[Role.find_by_name('admin')]
      user.save
    end
  end

  desc "Run all bootstrapping tasks"                                                                                                                                          
  task :all => [:admin_users]

end
