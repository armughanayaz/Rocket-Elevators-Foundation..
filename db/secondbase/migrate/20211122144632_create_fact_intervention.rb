class CreateFactIntervention < ActiveRecord::Migration[5.2]
  def change
    create_table :fact_interventions do |t|
      t.bigint :employeeID, null: false
      t.bigint :buildingID, null: false
      t.bigint :batteryID 
      t.bigint :columnID
      t.bigint :elevatorID
      t.datetime :dateAndTimeInterventionStart,  null: false
      t.datetime :dateAndTimeInterventionEnd,  null: false
      t.string :result, null: false
      t.string :report
      t.string :status, null: false
    end
  end
end
