require "uri"
require "http/client"

class Delta::Vav::Client
            property base_url : String

            ENDPOINTS_URL = "/?alt=json"

            def initialize(@base_url : String)
            end

            def test
                url = URI.parse(@base_url).resolve(ENDPOINTS_URL).to_s
                response = HTTP::Client.get url
                response.body
                raise Exception.new("Failed to login") if response.status_code != 200
            end


end
