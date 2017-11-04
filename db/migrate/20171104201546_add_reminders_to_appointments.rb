class AddRemindersToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :reminder, :string
  end
end
