require 'dropbox-api'
require 'dropbox_api'


class ApplicationController < ActionController::Base
    helper_method :dropbox

    def connectDropbox
        token = "oEtmw2a3jcYAAAAAAAAAAZCpoqIRP3mq8gda7wj0O12Oxqgvf72lYk8bIQ5OF2Lt"
        key = "nmhljn1ltn9hlz2"
        secret = "8amfyjy9pqcuw72"
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

    # def detectPresence(client, content, name)
    #     content.each do |x|
    #         if content.include? name
    #             return true
    #         end
    #     end
    #     return false
    # end

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
                lead.file  = nil
            end

        end
    end
end
