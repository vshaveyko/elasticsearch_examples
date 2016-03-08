class Authorship < ActiveRecord::Base

  include Elasticsearch::Model

  document_type "default"

  belongs_to :author
  belongs_to :article, touch: true

end
