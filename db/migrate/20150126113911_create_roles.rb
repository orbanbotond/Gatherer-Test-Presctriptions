class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :role_name

      t.timestamps null: false
    end
    add_foreign_key :roles, :users
    add_foreign_key :roles, :projects
  end
end
