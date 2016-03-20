task :base_index do
  RakeHelper.clear_index(Article)
  RakeHelper.clear_data
  RakeHelper.generate_data(1)
  RakeHelper.import_data(Article)
  pry binding
end
