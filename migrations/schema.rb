ActiveRecord::Schema.define(version: 1) do

  create_table :categories do |t|
    t.string     :title
    t.timestamps
  end

  create_table :authors do |t|
    t.string     :first_name, :last_name
    t.timestamps
  end

  create_table :authorships do |t|
    t.references :article
    t.references :author
    t.timestamps
  end

  create_table :articles do |t|
    t.string   :title
    t.timestamps
  end

  create_table :articles_categories, id: false do |t|
    t.references :article, :category
  end

  create_table :comments do |t|
    t.string     :text
    t.references :article
    t.timestamps
  end

  add_index(:comments, :article_id)

end
