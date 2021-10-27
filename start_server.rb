require 'html'
require 'sinatra'
require_relative 'db/database_sqlite'
require_relative 'authentication'

def db
  DB.new 'db/elternsprechtag.sqlite'
end

Dir[File.join('components','*.rb')].each do |file|
  require_relative File.join(File.dirname(file), File.basename(file, '.rb'))
end
