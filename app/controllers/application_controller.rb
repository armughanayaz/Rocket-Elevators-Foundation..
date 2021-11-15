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

        speech_to_text = IBMWatson::SpeechToTextV1.new(
            authenticator: authenticator
        )
        msg = "Hello"
        speech_to_text.service_url = "https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/fae3fc6d-4447-4d5a-b798-eb26daa0295f"

        puts JSON.pretty_generate(speech_to_text.list_models.result)

        puts JSON.pretty_generate(speech_to_text.get_model(model_id: "en-US_BroadbandModel").result)

        File.open("goodbye-prompt.wav") do |audio_file|
                prompt = text_to_speech.add_custom_prompt(
                customization_id: "test1",
                prompt_id: "goodbye",
                metadata: {
                    'prompt_text': 'Thank you and good-bye!',
                    'speaker_id': 'ted1'
                },
                file: audio_file
            )
            puts JSON.pretty_generate(recognition)
        end

    end
end
