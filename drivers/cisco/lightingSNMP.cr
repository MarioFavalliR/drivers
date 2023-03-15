require "placeos-driver"
require "snmp"

class LightingSNMP::Driver < PlaceOS::Driver
    descriptive_name "Cisco Lighting SNMP"
    generic_name : LightingSNMP

    default_settings({
        oid: ""
    })

    @oid : String = ""


    def on_load
        on_update
    end

    def on_update
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 2)
        socket.sync = false
        socket.read_timeout = 3
        @oid = setting(String, :oid)
    end

    def on()
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 161)
        socket.sync = false
        socket.read_timeout = 3
        session = SNMP::Session.new("TORIC-SNMP")
        socket.write_bytes session.set(@oid, 1)
        socket.flush   
        #response = session.parse(socket.read_bytes(ASN1::BER))
        self["state"] = "on"
    end

    def off()
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 161)
        socket.sync = false
        socket.read_timeout = 3
        session = SNMP::Session.new("TORIC-SNMP")
        socket.write_bytes session.set(@oid, 2)
        socket.flush   
        #response = session.parse(socket.read_bytes(ASN1::BER))
        self["state"] = "off"
    end
end