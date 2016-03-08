namespace :elastic do

  client = Elasticsearch::Client.new(log: true)
  model = Article
  model.__elasticsearch__.delete_index! if model.__elasticsearch__.index_exists?
  index_name = model.model_name.collection.gsub(/\//, '-')
  reindexing_block = -> (record) { record.__elasticsearch__.index_document }
  create_index = lambda do |index_name, index_settings|
    client.indices.create index: index_name, type: 'default', body: index_settings
  end

  task :index1 do
    index_settings = YAML.load_file("settings/settings_1.yml")
    create_index.(index_name, index_settings)
    model.all.map(&reindexing_block)
  end

end
