require 'dropbox-api'
require 'dropbox_api'
require "ibm_watson/speech_to_text_v1"
require "ibm_watson/websocket/recognize_callback"
require "ibm_watson/authenticators"
require "json"
require "ibm_watson"
require 'sendgrid-ruby'




class ApplicationController < ActionController::Base
    include SendGrid
    helper_method :watson
    
    def watson
        authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_APIKEY"]
        )

        text_to_speech = IBMWatson::TextToSpeechV1.new(
            authenticator: authenticator
        )

        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
        
        message = "Hi #{current_user.employee.first_name}. #{Elevator::count} elevators are presently deployed in all the #{Building::count} 
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




    helper_method :dropbox

    def connectDropbox
        token = ENV["DROPBOX_TOKEN"]
        key = ENV["DROPBOX_KEY"]
        secret = ENV["DROPBOX_SECRET"]
        Dropbox::API::Config.app_key    = key
        Dropbox::API::Config.app_secret = secret
        Dropbox::API::Config.mode       = "sandbox" # if you have a single-directory app
        return DropboxApi::Client.new(token)
    end

    def listDirectory(client, path)
        result = []
        entries = client.list_folder(path).entries
        entries.each do |entry|
            result.append(entry.path_lower)
        end
        result
    end

    def createFolder(client, location, name)
        content = listDirectory(client, location)
        if !"#{content}".include? name.downcase
            client.create_folder("#{location}#{name}")
        end
    end

    def removeFolder(client, location, name)
        content = listDirectory(client, location)
        if content.include? name
            client.delete("#{location}#{name}")
        end
    end

    def uploadFile(client, location, filename, file_content)
        content = listDirectory(client, location)
        if !"#{content}".include? filename
            client.upload("#{location}#{filename}", file_content)
        end
    end

    def leadIsCustomer(lead)
        fullNameLead = lead.fullNameContact
        emailLead = lead.email
        phoneNumberLead = lead.phoneNumber

       asscociatedCustomer = Customer.find_by(email: emailLead, contactPhone: phoneNumberLead)
       if asscociatedCustomer
            return true
        end
        return false
    end

    def dropbox
        client = connectDropbox
        root_content = listDirectory(client, '')
        createFolder(client, '', '/customers')
        receivedLeads = Lead.all
        receivedLeads.each do |lead|
            filecontent = lead.file
            if leadIsCustomer(lead)
                createFolder(client, '/customers', "/#{lead.compagnyName}")
                uploadFile(client, "/customers/#{lead.compagnyName}", "/attached_file_#{lead.id}.bin", filecontent)
                lead.update({file: nil})
            end
        end
        ''
    end
end

