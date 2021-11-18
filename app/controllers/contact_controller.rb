require 'sendgrid-ruby'

class ContactController < ApplicationController
    def create
      unless params[:contact].nil?
        @contact = Lead.new(contact_params)
        @contact.date = DateTime.now

        if @contact.save
          sendgrid(@contact)
          flash[:notice] = 'Message sent successfully'
          redirect_to root_url action: :new
        else
            render :new 
        end
        zendesk
      end
    end

    def zendesk
      ZendeskAPI::Ticket.create!($client, :subject => "#{@contact.fullNameContact} from #{@contact.compagnyName} ", :comment => { :value => "Comment: The contact #{@contact.fullNameContact} from company #{@contact.compagnyName} can be reached at email  #{@contact.email} and at phone number #{@contact.phoneNumber}. 
                                                                                                                                                              #{@contact.department} has a project named #{@contact.nameProject} which would require contribution from Rocket Elevators. 
                                                                                                                                                              #{@contact.descriptionProject}
                                                                                                                                                              Attached Message: #{@contact.message}
                                                                                                                                                     The Contact uploaded an attachment"}, :submitter_id => $client.current_user.id , :priority => "urgent", :type => "question")
    end

    def sendgrid(lead)
      puts 'sendgrid'
      mail = Mail.new
      mail.from = Email.new(email: 'rocketelevators13@gmail.com')
      custom = Personalization.new
      custom.add_to(Email.new(email: lead.email))
      custom.add_dynamic_template_data({
          "fullNameContact" => lead.fullNameContact,
          "nameProject" => lead.nameProject
      })
      mail.add_personalization(custom)
      mail.template_id = 'd-d25e6394d3434930835982c01f5eb980'

      testing1 = SendGrid::API.new(api_key: ENV['SENDGRID_APIKEY'])

      response = testing1.client.mail._('send').post(request_body: mail.to_json)
      
  end
     private
     def contact_params
       params.require(:contact).permit(:fullNameContact, :email, :phoneNumber, :compagnyName, :nameProject, :descriptionProject, :department, :message, :file) 
     end
end