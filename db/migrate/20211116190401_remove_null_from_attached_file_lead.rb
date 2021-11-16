class RemoveNullFromAttachedFileLead < ActiveRecord::Migration[5.2]
  def change
    change_column :leads, :file, :binary, null: true
  end
end
