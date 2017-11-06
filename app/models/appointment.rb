
class Appointment < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :time, presence: true
  belongs_to :user

  after_create do
    delay.twilio_reminder(self.reminder)
  end

  def twilio_reminder(body)
    @twilio_number = ENV['TWILIO_NUMBER']
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    @client = Twilio::REST::Client.new account_sid, ENV['TWILIO_AUTH_TOKEN']
    time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
    message = @client.api.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :body => body,
    )
  end

  def when_to_run
    minutes_before_appointment = 1.minutes
    time - minutes_before_appointment
  end

  handle_asynchronously :twilio_reminder, :run_at => Proc.new { |i| i.when_to_run }
end
