require "placeos-driver"
require "./vav/**"

#
# Documentation: C:\Program Files (x86)\Delta Controls\enteliWEB\website\help\en\guides\devguide.html
class Delta::Driver < PlaceOS::Driver
    descriptive_name "Delta systems"
    generic_name : Delta
    uri_base "http://eti-delta.ioetoronto.ca/enteliweb/"

    alias Client = Delta::Vav::Client

    default_settings({
    username: "YOUR_USERNAME",

    # Should be the same as set in the Fusion configuration client
    password: "YOUR_PASSWORD",
  })

    def on_load
        on_update
    end

    def on_update
        host_name = config.uri.not_nil!.to_s

        @client = Client.new(base_url:host_name)

    end
    
    def test()
        @client.try(&.test)
        self["state"] = "test"
    end
end
