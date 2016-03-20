task :dynamic_template_index do
  index_settings = YAML.load_file("settings/dynamic_templates_settings.yml")
  RakeHelper.create_index(Article, index_settings)
  RakeHelper.import_to_index(Article)
  RakeHelper.create_simple_index
  RakeHelper.clear_data
  RakeHelper.generate_data(1)
  pry binding
end
