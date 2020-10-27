class AddContaTransferenciaIdToMovimentacoes < ActiveRecord::Migration[6.0]
  def change
    add_column :movimentacoes, :conta_transferencia_id, :integer
  end
end
