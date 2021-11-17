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
end
