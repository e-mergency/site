default:
	rake db:mongoid:create_indexes
	rake bootstrap:all
	rake test:units
	rake cucumber
	rake test_data:all
