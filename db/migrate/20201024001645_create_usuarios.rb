class CreateUsuarios < ActiveRecord::Migration[6.0]
  def change
    create_table :usuarios do |t|
      t.string :nome, null: false
      t.string :cpf, null: false, unique: true

      t.timestamps
    end
  end
end
