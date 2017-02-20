# docs
class CreatePhoto < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :image_uid
    end
  end
end
