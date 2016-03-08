# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# $LOAD_PATH.unshift File.expand_path('migrations', __FILE__)
# $LOAD_PATH.unshift File.expand_path('models', __FILE__)

#  ---- dependencies ---
require 'pry'
require 'logger'
require 'ansi/core'
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

# ----- Elasticsearch client setup ----------------------------------------------------------------

client = Elasticsearch::Model.client = Elasticsearch::Client.new(log: true)
Elasticsearch::Model.client.transport.logger.formatter = proc { |s, d, p, m| "\e[32m#{m}\n\e[0m" }

# ----- Search integration ------------------------------------------------------------------------

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    include Indexing
    after_touch() { __elasticsearch__.index_document }
  end

  module Indexing

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})
      self.as_json(
        include: { categories: { only: :title},
                   authors:    { methods: [:full_name], only: [:full_name] },
                   comments:   { only: :text }
                 })
    end
  end
end
# --- load models ---

require_relative 'migrations/schema' unless ActiveRecord::Migration.table_exists? :categories
Dir.glob('models/*.rb').each { |r| require_relative r }

# ----- Insert data -------------------------------------------------------------------------------

category = Category.create title: 'One'
author = Author.create first_name: 'John', last_name: 'Smith'
article  = Article.create title: 'First Article'
article.categories << category
article.authors << author
article.comments.create text: 'First comment for article One'
article.comments.create text: 'Second comment for article One'

client.indices.refresh index: Elasticsearch::Model::Registry.all.map(&:index_name)

puts "\n\e[1mArticles containing 'one':\e[0m", Article.search('one').records.to_a.map(&:inspect), ""

puts "\n\e[1mModels containing 'one':\e[0m", Elasticsearch::Model.search('one').records.to_a.map(&:inspect), ""

Kernel.system "curl -XGET 'http://localhost:9200/articles'"


binding.pry
