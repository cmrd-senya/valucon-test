# docs
class CreateRailsGemsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :rails_gems do |t|
      t.string :version, null: false
      t.string :gem_copy, null: false
      t.string :sha, null: false
    end
  end
end
