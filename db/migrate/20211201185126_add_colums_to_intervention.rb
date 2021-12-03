class AddColumsToIntervention < ActiveRecord::Migration[5.2]
  def change
    add_column :interventions, :author, :bigint, null:false
  end
end
