class Elevator < ApplicationRecord    
    after_update :slack
    def slack_message
        statusChanges = self.previous_changes[:status]
        elevatorID = self.id
        serialNumber = self.serialNumber
        oldStatus = statusChanges[statusChanges.length - 2]
        newStatus = self.status
        "The Elevator #{elevatorID} with Serial Number #{serialNumber} changed status from #{oldStatus} to #{newStatus}"
    end

    def slack
        message = slack_message
        Slack.configure do |config|
            config.token = ENV['SLACK_API_TOKEN']
        end
        client = Slack::Web::Client.new
        response = client.chat_postMessage(channel: '#elevator_operations', text: message, as_user: true)

        # teamgooglecloud channel in Cobeboxx workspae
        # Slack.configure do |config|
        #     config.token = ENV['SLACK_API_TOKEN_DEV']
        # end
        # client = Slack::Web::Client.new
        # client.chat_postMessage(channel: 'C02LLLYB344', text: "#{message}", as_user: true)
    end


    after_update :twilio
    def twilio_sms
        elevatorID = self.id
        "The Elevator #{elevatorID} needs maintenance!"
    end

    # attr_accessor :account_sid, :auth_token, :twilio_client
    def twilio_client
        account_sid = ENV["account_sid"]
        auth_token = ENV["auth_token"]
        Twilio::REST::Client.new(account_sid, auth_token)
    end

    def twilio
        client = twilio_client
        sms = twilio_sms
        if self.status == 'intervention'
            client.messages.create(
                    from: '+18195104642',
                    to: ENV["phone_number"],
                    body: "#{sms}"           )
        end
    end
end
