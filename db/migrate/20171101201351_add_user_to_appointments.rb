class AddUserToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_reference :appointments, :user, foreign_key: true
  end
end
