require "logger"

ActiveRecord::Base.establish_connection({
  :adapter   => "mysql2",
  :database  => "dareuma",
  :username => "root",
  :pool => 5,
  :encoding => "utf8",
})

ActiveRecord::Base.logger = Logger.new($stderr)