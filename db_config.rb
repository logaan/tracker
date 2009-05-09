DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/tracker.sqlite3")
DataMapper.auto_migrate!

