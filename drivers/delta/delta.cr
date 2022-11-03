require "placeos-driver"
require "uri"
require "json"
require "xml"

#
# Documentation: C:\Program Files (x86)\Delta Controls\enteliWEB\website\help\en\guides\devguide.html
class Delta::Driver < PlaceOS::Driver
    descriptive_name "Delta systems"
    generic_name : Delta
    uri_base "http://eti-delta.ioetoronto.ca/enteliweb"

    default_settings({
    auth: "YOUR_AUTH",
    host: "YOUR_HOST"
  })

  @auth : String = ""
  @host : String = ""

    def on_load
        on_update
    end

    def on_update
        @auth = setting(String, :auth)
    end

    def get_sites()
    response = get(
      generate_url("/api/.bacnet?alt=json"),
      headers: generate_headers
    )
    response.body

  end

  def get_devices(site_id : String)
    response = get(
      generate_url("/api/.bacnet/#{site_id}?alt=json"),
      headers: generate_headers
    )
    response.body
  end

  def get_objects(site_id : String, device_id : String, skip : Int64, max_results : Int64)
    response = get(
      generate_url("/api/.bacnet/#{site_id}/#{device_id}?skip=#{skip}&max-results=#{max_results}&alt=json"),
      headers: generate_headers
    )
    response.body
  end


  def get_values(site_id : String, device_id : String, object_id : String)
    response = get(
      generate_url("/api/.bacnet/#{site_id}/#{device_id}/#{object_id}?alt=json"),
      headers: generate_headers
    )
    response = Hash(String, JSON::Any).from_json(response.body)
    puts response
    self["state"] = response["status"]["value"]
    self["start_type"] = response["start-type"]["value"]
  end

    private def generate_url(
        path : String,
        )
        URI.encode("#{path}")
      end

    private def generate_headers(
        headers : Hash(String, String) = {} of String => String
        )
        # Recommended to use this header in docs
        headers["Authorization"] = @auth
        headers["Host"] = @host
        headers
    end
end

