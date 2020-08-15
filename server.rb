require 'socket'
require 'whois-parser'
require 'uri'

server = TCPServer.new ENV['PORT']

while session = server.accept
  request = session.gets
  whois_data = {}
  contact_data = ["address", "city", "country", "country_code", "email", "fax", "id", "name", "organization", "phone", "state", "updated_on", "created_on", "url", "zip"]
  
  begin
    method, path = request.split(' ')
    site = path.to_str.match(/site=([^$|&]+)/si)[1]
    site = "http://#{site}" unless site.start_with?('http')
    hostname = URI.parse(site).host.downcase

    if hostname
      record = Whois.whois(hostname)
      parser = record.parser
      for prop in Whois::Parser::PROPERTIES
        begin
          data = parser.send(prop)
          if data.first.to_s.include? "Whois::Parser::Contact"
            whois_data["#{prop}_props"] = {}
            contact_data.each { |k| whois_data["#{prop}_props"][k] = data.first[k] }
          end
        rescue
        end

        begin
          whois_data[prop] = parser.send(prop)
        rescue
        end
      end
    end

    session.print "HTTP/1.1 200\r\n"
    session.print "Content-Type: application/json; charset=utf-8\r\n" 
    session.print "Access-Control-Allow-Origin: *\r\n"
    session.print "Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept\r\n"
    session.print "\r\n"
    session.print whois_data.to_json

    session.close
  rescue

    begin
      session.print "HTTP/1.1 400\r\n"
      session.print "\r\n"
      session.close
    rescue
    end

  end
end
