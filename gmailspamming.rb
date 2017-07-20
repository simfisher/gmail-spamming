require 'gmail'
require "rubygems"
require "google_drive"
require_relative 'config_gmail'
require "json"
require 'omniauth-google-oauth2'


def send_email(email,mail_content,mail_subject)
	variables = get_variables
	gmail = Gmail.connect(variables[0], variables[1])
	gmail.deliver do
	  to email
	  cc "simon.bensaid@gmail.com"
	  subject mail_subject
	  #text_part do
	  #  body mail_content
	  #end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body mail_content
	    puts "Mail sent to #{email}"
	  end
	end
	gmail.logout
end

def get_email_from_spreadsheet(key)
	email_hash={}
	i=2
	session = GoogleDrive::Session.from_config("config.json") #ligne pour se connecter à l'API google drive
	ws = session.spreadsheet_by_key(key).worksheets[0] #ligne pour ouvrir la spreadsheet
	(ws.num_rows-1).times do
		email_hash[ws[i,1]] = ws[i,2]
		i+=1
	end
	return email_hash
end

def mail_writing(town)

	content = "
	<p>Cher(e) dodolasaumure,</p>
	<p>Nous nous permettons de vous contacter dans le cadre de la formation que nous suivons : <a href='http://thehackingproject.org/'>The Hacking Project</a>.</p>

	<p>simon.bensaid@gmail.com</p>
	"
	return content
end

def perform

	spreadsheet_key = "" 
	email_hash = get_email_from_spreadsheet(spreadsheet_key)
	email_hash.keys.each do |town|
		mail_content = mail_writing(town)
		send_email(email_hash[town],mail_writing(town),"A destination du maire de #{town} - THP - RSVP avant le 28 juillet")
	end

end

perform
