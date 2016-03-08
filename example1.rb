require_relative 'config'

# ----- Fill data -------------------------------------------------------------------------------

category = Category.create title: 'One'
author = Author.create first_name: 'John', last_name: 'Smith'
article  = Article.create title: 'First Article'
article.categories << category
article.authors << author
article.comments.create text: 'First comment for article One'
article.comments.create text: 'Second comment for article One'

client.indices.refresh index: Elasticsearch::Model::Registry.all.map(&:index_name)

# --- check data --
puts "\n\e[1mArticles containing 'one':\e[0m", Article.search('one').records.to_a.map(&:inspect), ""

puts "\n\e[1mModels containing 'one':\e[0m", Elasticsearch::Model.search('one').records.to_a.map(&:inspect), ""

Kernel.system "curl -XGET 'http://localhost:9200/articles'"

pry binding
