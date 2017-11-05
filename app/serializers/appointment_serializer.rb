class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_number, :time, :reminder
end
