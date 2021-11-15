require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"


class ApplicationController < ActionController::Base
    helper_method :watson

    def watson
        authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
            apikey: "3IjEtQxRYd5hHScxyl1I5n5Ob9_t88PnYYmR1RIY1I1R"
        )

        speech_to_text = TextToSpeechV1.new(
            authenticator: authenticator
        )

        speech_to_text.service_url = "https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/fae3fc6d-4447-4d5a-b798-eb26daa0295f"
        
        output_file = File.new("output.wav", "w")
        output_file.close
            
        response = speech_to_text.synthesize(
            text: "Hello world!",
            accept: "audio/wav",
            voice: "en-US_AllisonVoice"
          ).result
        return response
    end
end
