class Comment < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  document_type "default"

  belongs_to :article, touch: true

end
