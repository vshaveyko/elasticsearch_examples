unless ActiveRecord::Migration.table_exists? :categories
  ActiveRecord::Schema.define(version: 1) do

    create_table :categories do |t|
      t.string     :title
    end

    create_table :authors do |t|
      t.string     :first_name, :last_name
    end

    create_table :authorships do |t|
      t.references :article
      t.references :author
    end

    create_table :articles do |t|
      t.string   :title
    end

    create_table :articles_categories, id: false do |t|
      t.references :article, :category
    end

    create_table :comments do |t|
      t.string     :text
      t.references :article
    end

    add_index(:comments, :article_id)

  end
end
