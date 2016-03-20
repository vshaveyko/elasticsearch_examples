task :completion_suggester_index do
  RakeHelper.clear_index(Article)
  RakeHelper.clear_data
  RakeHelper.generate_data(2)
  Article.import(force: true)
  pry binding
end
