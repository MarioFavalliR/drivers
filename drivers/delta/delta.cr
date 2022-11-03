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
    credentials: {
      username: "",
      password: ""
    },

    evnironment: {
      host: "",
      site_id: "",
      device_id: ""
    }})



  @username : String = ""
  @password : String = ""
  @auth : String = ""
  @host : String = ""
  @site_id : String = ""
  @device_id : String = ""
  @object_id : String = ""


    def on_load
        on_update
    end

    def on_update
      encoded  = Base64.encode("#{@username}:#{@password}")
      encoded = "Basic #{encoded}"
      @auth = setting(String, :encoded)
      @site_id = setting(String, :site_id)
    end

    def get_sites()
    response = get(
      generate_url("/api/.bacnet?alt=json"),
      headers: generate_headers
    )
    response.body

  end

  def get_devices()
    response = get(
      generate_url("/api/.bacnet/#{@site_id}?alt=json"),
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
    response.body
    response = Hash(String, JSON::Any).from_json(response.body)
    self["state"] = response["present-value"]["value"]
    self["start_type"] = response["start-type"]["value"]
  end

  def put_status_values(site_id : String, device_id : String, object_id : String, value : String)
    response = put(
      generate_url("/api/.bacnet/#{site_id}/#{device_id}/#{object_id}/present-value?alt=json"),
      headers: generate_headers,
      body: generate_body({
        "$base" => "Enumerated",
        "value" => "#{value}",
      }),
    )
    response.body
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

    private def generate_body(
      body : Hash(String, String) = {} of String => String,
      )
      body.to_json
  end
end

