require "json"
require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
include IBMWatson

class ApplicationController < ActionController::Base
    helper_method :watson

    def watson
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: "{apikey}"
        )

        text_to_speech = TextToSpeechV1.new(
            authenticator: authenticator
        )
        text_to_speech.service_url = "{url}"

        voices = text_to_speech.list_voices
        return JSON.pretty_generate(voices.result)
    end
end
