class Article < ActiveRecord::Base

  include ::Searchable

  document_type "default"

  # completion_suggester_settings
  # settings do
  #   mappings do
  #     indexes :title, analyzer: 'keyword'
  #     indexes :suggest, type: 'completion', index_analyzer: 'simple', search_analyzer: 'simple', payloads: true
  #   end
  # end

  # Other options are:

  # preserve_separators
  # Preserves the separators, defaults to true.
  # If disabled, you could find a field starting with Foo Fighters, if you suggest for foof.

  # preserve_position_increments
  # Enables position increments, defaults to true.
  # If disabled and using stopwords analyzer, you could get a field starting with The Beatles, if you suggest for b.
  # Note: You could also achieve this by indexing two inputs, Beatles and The Beatles,
  # no need to change a simple analyzer, if you are able to enrich your data.

  # max_input_length
  # Limits the length of a single input, defaults to 50 UTF-16 code points.

  # search_analyzer

  has_and_belongs_to_many :categories, after_add:    [ lambda { |a,c| a.__elasticsearch__.index_document } ],
                                       after_remove: [ lambda { |a,c| a.__elasticsearch__.index_document } ]
  has_many                :authorships
  has_many                :authors, through: :authorships
  has_many                :comments

end
