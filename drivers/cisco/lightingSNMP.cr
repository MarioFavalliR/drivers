require "placeos-driver"
require "snmp"

class LightingSNMP::Driver < PlaceOS::Driver
    descriptive_name "Cisco Lighting SNMP"
    generic_name : LightingSNMP
    
    default_settings({
        ip: "",
        port: ""
    })

    @ip : String = ""
    @port : String = ""

    def on_load
        on_update
    end

    def on_update
        ip = @ip
        port = @port
    end

    def on()
        socket = UDPSocket.new
        socket.connect(@ip, 161)
        socket.sync = false
        session = SNMP::Session.new
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 2)
        socket.flush
        response = session.parse(socket.read_bytes(ASN1::BER))
        
        self["state"] = response.value.get_string
    end

    def off()
        socket = UDPSocket.new
        socket.connect(@ip, 161)
        socket.sync = false
        session = SNMP::Session.new
        socket.write_bytes session.set("1.3.6.1.2.1.105.1.1.1.3.2", 1)
        socket.flush
        response = session.parse(socket.read_bytes(ASN1::BER))
        
        self["state"] = response.value.get_string
    end
end