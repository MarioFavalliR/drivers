require "placeos-driver"
require "snmp"

class LightingSNMP::Driver < PlaceOS::Driver
    descriptive_name "Cisco Lighting SNMP"
    generic_name : LightingSNMP


    def on_load
        on_update
    end

    def on_update
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 2)
        socket.sync = false
        socket.read_timeout = 3
    end

    def on()

    end

    def off()
    
    end
end