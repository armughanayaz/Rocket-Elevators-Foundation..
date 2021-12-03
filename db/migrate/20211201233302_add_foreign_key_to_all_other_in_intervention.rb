class AddForeignKeyToAllOtherInIntervention < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :interventions, :customers, column: :customerId, primary_key: 'id'
    add_foreign_key :interventions, :buildings, column: :buildingId, primary_key: 'id'
    add_foreign_key :interventions, :batteries, column: :batterieId, primary_key: 'id'
    add_foreign_key :interventions, :columns, column: :columnId, primary_key: 'id'
    add_foreign_key :interventions, :elevators, column: :elevatorId, primary_key: 'id'
    add_foreign_key :interventions, :employees, column: :employeeId, primary_key: 'id'
  end
end
