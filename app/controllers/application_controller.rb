require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"
require "ibm_watson"
require 'sendgrid-ruby'
include SendGrid

class ApplicationController < ActionController::Base
    helper_method :watson
    helper_method :sendgrid
                
    def watson
        authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_APIKEY"]
        )

        text_to_speech = IBMWatson::TextToSpeechV1.new(
            authenticator: authenticator
        )

        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
        
        # output_file = File.new("output.wav", "w")
        # output_file.close

        message = "Hi user #{current_user.id}. #{Elevator::count} elevators are presently deployed in all the #{Building::count} 
                buildings of your #{Customer::count} customers. Currently, #{Elevator.where(status: 'offline').count} elevators are not in Running Status 
                and are being serviced.  #{Quote::count} quotes are awaiting processing.  #{Lead::count} leads are currently registered in your contacts. 
                #{Batterie::count} Batteries are deployed across #{Address.where(id: Building.select(:addressid).distinct).select(:city).distinct.count} cities."
                
                
            
        
        File.open("public/hello_world.wav", "wb") do |audio_file|
        response = text_to_speech.synthesize(
            text: message,
            accept: "audio/wav",
            voice: "en-US_AllisonVoice"
          ).result
        audio_file.write(response)
        end
        return ''
    end

    
    
    def sendgrid(lead)
        mail = Mail.new
        mail.from = Email.new(email: 'rocketelevators11@gmail.com')
        custom = Personalization.new
        custom.add_to(Email.new(email: lead.email))
        custom.add_dynamic_template_data({
            "fullName" => lead.fullNameContact,
            "projectName" => lead.nameProject
        })
        mail.add_personalization(custom)
        mail.template_id = 'd-d25e6394d3434930835982c01f5eb980'

        testing1 = SendGrid::API.new(api_key: ENV['SENDGRID_APIKEY'])

        response = testing1.client.mail._('send').post(request_body: mail.to_json)
        
    end
end
