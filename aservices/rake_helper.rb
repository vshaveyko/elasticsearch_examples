require 'database_cleaner'
require 'faker'
class RakeHelper

  @client = Elasticsearch::Client.new(log: true)
  @reindexing_block = -> (record) { record.__elasticsearch__.index_document }

  class << self

    def create_index(model, index_settings)
      clear_index(model)
      @client.indices.create index: index_name(model), type: 'default', body: index_settings
    end

    def index_name(model)
      model.model_name.collection.gsub(/\//, '-')
    end

    def clear_index(model)
      model.__elasticsearch__.delete_index! if model.__elasticsearch__.index_exists?
    end

    def import_data(model)
      model.all.map &@reindexing_block
    end

    def create_simple_index(*models)
      models = [Authorship, Author] if !models || models.empty?
      models.each do |model|
        model.__elasticsearch__.create_index! unless model.__elasticsearch__.index_exists?
      end
    end

    def clear_data
      DatabaseCleaner.clean_with(:truncation)
    end

    def generate_data(settings_index)
      send "generate_settings#{settings_index}_data"
    end

    def generate_settings1_data
      category = Category.create title: Faker::Lorem.sentence
      author = Author.create first_name: Faker::Lorem.word, last_name: Faker::Lorem.word
      article = Article.create title: Faker::Lorem.sentence
      article.categories << category
      article.authors << author
      article.comments.create text: Faker::Lorem.sentence
      article.comments.create text: Faker::Lorem.sentence
    end

    def generate_settings2_data
      Faker::Lorem.words(5).each_cons(2) do |word, next_word|
        3.times do
          article = Article.create title: word + ' ' + Faker::Lorem.sentence + ' ' + next_word
          article.comments.create text: Faker::Lorem.sentence
          article.comments.create text: Faker::Lorem.sentence
        end
      end
    end

    def suggest(query, model)
      @client.suggest(index: index_name(model), body: {
        suggestions: {
          text: query,
          completion: {
            field: 'suggest',
            size: 20
          }
        }
      })
    end

  end
end
