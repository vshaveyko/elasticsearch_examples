module Searchable

  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    include Indexing
    after_touch() { __elasticsearch__.index_document }
  end

  module Indexing

    ### Customize the JSON serialization for Elasticsearch

    ### For nested index example
    def as_indexed_json(options={})
      self.as_json(
        include: { categories: { only: :title},
                   authors:    { methods: [:full_name], only: [:full_name] },
                   comments:   { only: :text }
                 })
    end

    ### FOR completion suggester
    # def as_indexed_json(options={})
    #   self.as_json(only: :title).merge({
    #     suggest: {
    #       input: title,
    #       output: title,
    #       payload: { id: id }
    #     }
    #   })
    # end

    ### simpliest index for other examples
    # def as_indexed_json(options={})
    #   self.as_json(only: :title)
    # end
  end

end
