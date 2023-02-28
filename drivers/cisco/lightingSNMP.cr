require "placeos-driver"
require "snmp"

class LightingSNMP::Driver < PlaceOS::Driver
    descriptive_name "Cisco Lighting SNMP"
    generic_name : LightingSNMP
    

    def on_load
        on_update
    end

    def on_update
        session = SNMP::Session.new
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 2)
        socket.sync = false
        response = session.parse(socket.read_bytes(ASN1::BER))
        response.value.get_string
    end

    def on()
        session = SNMP::Session.new
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 2)
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 2)
        socket.flush
        response = session.parse(socket.read_bytes(ASN1::BER))
        
        self["state"] = response.value.get_string
    end

    def off()
        session = SNMP::Session.new
        socket = UDPSocket.new
        socket.connect("192.168.20.253", 2)
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 1)
        socket.flush
        response = session.parse(socket.read_bytes(ASN1::BER))
        
        self["state"] = response.value.get_string
    end
end