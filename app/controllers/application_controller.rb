require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"
require "ibm_watson"

class ApplicationController < ActionController::Base
    helper_method :watson
                
    def watson
        authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
            apikey: "3IjEtQxRYd5hHScxyl1I5n5Ob9_t88PnYYmR1RIY1I1R"
        )

        text_to_speech = IBMWatson::TextToSpeechV1.new(
            authenticator: authenticator
        )

        text_to_speech.service_url = "https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/fae3fc6d-4447-4d5a-b798-eb26daa0295f"
        
        # output_file = File.new("output.wav", "w")
        # output_file.close
        
        File.open("public/hello_world.wav", "wb") do |audio_file|
        response = text_to_speech.synthesize(
            text: "Hello Hi!",
            accept: "audio/wav",
            voice: "en-US_AllisonVoice"
          ).result
        audio_file.write(response)
        end
        return ''
    end
end
