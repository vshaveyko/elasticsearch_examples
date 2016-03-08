class Category < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  document_type "default"

  has_and_belongs_to_many :articles

end
