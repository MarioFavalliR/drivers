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
    username: "YOUR_USERNAME",

    # Should be the same as set in the Fusion configuration client
    password: "YOUR_PASSWORD",
  })

  @username : String = ""
  @password : String = ""

    def on_load
        on_update
    end

    def on_update
        @username = setting(String, :username)
        @password = setting(String, :password)
    end

    def get_response()
    response = get(
      generate_url("/api?alt=json"),
      headers: generate_headers({
        "Authorization"     => "Basic YWRtaW46cGFzc3dvcmQ=",
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

