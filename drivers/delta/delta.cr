require "placeos-driver"
require "./vav/**"

#
# Documentation: C:\Program Files (x86)\Delta Controls\enteliWEB\website\help\en\guides\devguide.html
class Delta::Driver < PlaceOS::Driver
    descriptive_name "Delta systems"
    generic_name : Delta
    uri_base "http://eti-delta.ioetoronto.ca/enteliweb"

    alias Client = Delta::Vav::Client

    default_settings({
    auth: "YOUR_AUTH",

    # Should be the same as set in the Fusion configuration client
  })

  @auth : String = ""

    def on_load
        on_update
    end

    def on_update
        @auth = setting(String, :auth)
    end

    def get_sites()
    response = get(
      generate_url("/api/.bacnet/"),
      headers: generate_headers({
        "Authorization"     => @auth,
      })
    )
    response.body
  end

  def get_devices(site_id : String)
    response = get(
      generate_url("/api/.bacnet/#{site_id}"),
      headers: generate_headers({
        "Authorization"     => @auth,
      })
    )
    response.body
  end

  def get_objects(site_id : String, device_id : String, skip : Int64, max_results : Int64)
    response = get(
      generate_url("/api/.bacnet/#{site_id}/#{device_id}?skip=#{skip}&max-results=#{max_results}"),
      headers: generate_headers({
        "Authorization"     => @auth,
      })
    )
    response.body
  end

    private def generate_url(
        path : String,
        )
        "#{path}"
      end

    private def generate_headers(
        headers : Hash(String, String) = {} of String => String
        )
        # Recommended to use this header in docs
        headers
    end
end

