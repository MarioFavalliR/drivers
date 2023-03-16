require "placeos-driver"
require "uri"
require "json"

#
# Documentation: C:\Program Files (x86)\Delta Controls\enteliWEB\website\help\en\guides\devguide.html
class Delta::Driver < PlaceOS::Driver
    descriptive_name "Delta systems"
    generic_name : Delta
    uri_base "http://demo.entelicloud.com/enteliweb"


    default_settings({
        username: "",
        password: "",
        host: "",
        site_id: "",
        device_id: "",
        object_id: "",
    })



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
      encoded  = Base64.strict_encode("#{setting(String, :username)}:#{setting(String, :password)}")
      @auth = "Basic #{encoded}"
      @site_id = setting(String, :site_id)
      @device_id = setting(String, :device_id)
      @object_id = setting(String, :object_id)
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

  def get_objects(skip : Int64, max_results : Int64)
    response = get(
      generate_url("/api/.bacnet/#{@site_id}/#{@device_id}?skip=#{skip}&max-results=#{max_results}&alt=json"),
      headers: generate_headers
    )
    response.body
  end


  def get_values()
    response = get(
      generate_url("/api/.bacnet/#{@site_id}/#{@device_id}/#{@object_id}?alt=json"),
      headers: generate_headers
    )
    response.body
    value = response.body.to_json
    self["state"] = JSON.parse(response.body)
  end

  def put_vav_values(value : String)
    response = put(
      generate_url("/api/.bacnet/#{@site_id}/#{@device_id}/#{@object_id}/manual-override?alt=json"),
      headers: generate_headers,
      body: generate_body({
        "$base" => "Enumerated",
        "value" => "#{value}",
      }),
    )
    response.body
    self["state"] = response.body
  end

  def accessControl_values(value : String)
    response = put(
      generate_url("/api/.bacnet/#{@site_id}/#{@device_id}/#{@object_id}/manual-override?alt=json"),
      headers: generate_headers,
      body: generate_body({
        "$base" => "Enumerated",
        "value" => "#{value}",
      }),
    )
    response.body
    self["state"] = value
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

