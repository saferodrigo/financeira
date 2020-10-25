class CreateContas < ActiveRecord::Migration[6.0]
  def change
    create_table :contas do |t|
      t.belongs_to :usuario, null: false, foreign_key: true
      t.decimal :saldo, null: false, default: 0.0
      t.integer :numero, null: false
      t.boolean :ativa, null: false, dafault: true

      t.timestamps
    end
  end
end
