require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"
require "ibm_watson"

class ApplicationController < ActionController::Base
    helper_method :watson
                
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
end
