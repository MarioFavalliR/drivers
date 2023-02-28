require "placeos-driver/spec"

DriverSpecs.mock_driver "Sony::Projector::SerialControl" do
  exec(:power, true)
  should_send("\xA9\x17\x2E\x00\x00\x00\x3F\x9A")
  responds("\xA9\x00\x00\x03\x00\x00\x03\x9A")
  should_send("\xA9\x17\x2E\x00\x00\x00\x3F\x9A")
  responds("\xA9\x00\x00\x03\x00\x00\x03\x9A")
  sleep 3
  # power?
  should_send("\xA9\x01\x02\x01\x00\x00\x03\x9A")
  responds("\xA9\x01\x02\x02\x00\x03\x03\x9A")
  status[:cooling].should eq(false)
  status[:warming].should eq(false)
  status[:power].should eq(true)

  exec(:switch_to, "hdmi")
  should_send("\xA9\x00\x01\x00\x00\x03\x03\x9A")
  responds("\xA9\x00\x00\x03\x00\x00\x03\x9A")
  # input?
  should_send("\xA9\x00\x01\x01\x00\x00\x01\x9A")
  responds("\xA9\x00\x01\x02\x00\x03\x03\x9A")
  status[:input].should eq("HDMI")

  exec(:mute)
  should_send("\xA9\x00\x30\x00\x00\x01\x31\x9A")
  responds("\xA9\x00\x00\x03\x00\x00\x03\x9A")
  # mute?
  should_send("\xA9\x00\x30\x01\x00\x00\x31\x9A")
  responds("\xA9\x00\x30\x02\x00\x01\x33\x9A")
  status[:mute].should eq(true)

  exec(:lamp_time?)
  should_send("\xA9\x01\x13\x01\x00\x00\x13\x9A")
  responds("\xA9\x01\x13\x02\x03\xE8\xFB\x9A")
  status[:lamp_usage].should eq(1000)

  exec(:power, false)
  should_send("\xA9\x17\x2F\x00\x00\x00\x3F\x9A")
  responds("\xA9\x00\x00\x03\x00\x00\x03\x9A")
  sleep 3
  # power?
  should_send("\xA9\x01\x02\x01\x00\x00\x03\x9A")
  responds("\xA9\x01\x02\x02\x00\x04\x07\x9A")
  status[:cooling].should eq(true)
  status[:warming].should eq(false)
  status[:power].should eq(false)
end
