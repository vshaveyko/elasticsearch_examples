#  ---- dependencies ---

require 'pry'
require 'logger'
require 'active_record'
require 'elasticsearch/model'

# --- establish db connection ---

ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'elasticsearch',
  encoding: 'utf8',
  collation: 'utf8_general_ci',
  username: 'root',
  password: 'root',
  pool: 5,
  timeout: 5000
)

# --- files ---

Dir.glob('*/*.rb').each { |r| require_relative r }
