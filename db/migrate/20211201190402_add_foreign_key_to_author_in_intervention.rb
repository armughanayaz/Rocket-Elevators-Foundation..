class AddForeignKeyToAuthorInIntervention < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :interventions, :employees, column: :author, primary_key: 'id'
  end
end
