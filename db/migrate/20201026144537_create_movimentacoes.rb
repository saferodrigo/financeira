class CreateMovimentacoes < ActiveRecord::Migration[6.0]
  def change
    create_table :movimentacoes do |t|
      t.belongs_to :conta, null: false, foreign_key: true
      t.decimal :valor, null: false
      t.integer :tipo, null: false

      t.timestamps
    end
  end
end
