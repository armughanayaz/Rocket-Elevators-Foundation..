class AddOtherColumnsToIntervention < ActiveRecord::Migration[5.2]
  def change
    add_column :interventions, :customerId, :bigint, null: false
    add_column :interventions, :buildingId, :bigint, null: false
    add_column :interventions, :batterieId, :bigint, null: false
    add_column :interventions, :columnId, :bigint
    add_column :interventions, :elevatorId, :bigint
    add_column :interventions, :employeeId, :bigint
    add_column :interventions, :start, :date
    add_column :interventions, :end, :date
    add_column :interventions, :result, :string
    add_column :interventions, :report, :string
    add_column :interventions, :status, :string
  end
end
