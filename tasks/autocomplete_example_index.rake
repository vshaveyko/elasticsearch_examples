task :autocomplete_example_index do
  index_settings = YAML.load_file("settings/autocomplete_settings.yml")
  RakeHelper.create_index(Article, index_settings)
  RakeHelper.clear_data
  RakeHelper.generate_data(2)
  RakeHelper.import_data(Article)
  pry binding
end
