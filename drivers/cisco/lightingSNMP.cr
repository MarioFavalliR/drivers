require "placeos-driver"
require "crystal-snmp"

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
    end

    def on()
        session = SNMP::Session.new
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 2)
        socket.flush
        self["state"] = "on"
    end

    def off()
        session = SNMP::Session.new
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 1)
        socket.flush
        self["state"] = "off"
    end
end