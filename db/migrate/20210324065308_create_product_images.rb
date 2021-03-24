class CreateProductImages < ActiveRecord::Migration[5.2]
  def change
    create_table :product_images do |t|
      t.bigint :product_id
      t.string :title
      t.string :handle

      t.timestamps
    end
  end
end
