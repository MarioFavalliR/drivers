require "placeos-driver/spec"

DriverSpecs.mock_driver "Extron::Matrix" do
  responds "\r\n"
  responds "(c) Copyright YYYY, Extron Electronics, [model], Vx.xx, 60-XXXX-XX\r\nMon, 18 May 2015 11:27:33\r\n\r\nPassword:"
  should_send "extron\x0D"
  responds "Login Administrator\r\n"
  sleep 1

  should_send "I"
  responds "V08X04 A8X4\r\n"

  exec :switch_one, input: 3, output: 2
  should_send "3*2!"
  responds "Out2 In3 All\r\n"
  status["video2"].should eq 3

  status["video_matrix"].should eq("8x4")
  status["audio_matrix"].should eq("8x4")

  exec :switch_to, input: 2
  should_send "2!"
  responds "In2 All\r\n"
  status["video1"].should eq 2
  status["video2"].should eq 2
  status["video3"].should eq 2
  status["video4"].should eq 2
  status["audio1"].should eq 2
  status["audio2"].should eq 2
  status["audio3"].should eq 2
  status["audio4"].should eq 2

  exec :switch_map, {1 => [2, 3, 4]}
  should_send "\e+Q1*2!1*3!1*4!\r"
  responds "Qik\r\n"
  status["video2"].should eq 1
  status["video3"].should eq 1
  status["video4"].should eq 1

  expect_raises PlaceOS::Driver::RemoteException do
    conflict = exec :switch_map, {1 => 1, 2 => 1}
    conflict.get
  end

  expect_raises PlaceOS::Driver::RemoteException do
    invalid = exec :switch_to, input: 999
    responds "E01\r\n"
    invalid.get
  end

  vol = exec :volume, level: 25
  should_send "\eD1*-750GRPM\r"
  responds "GrpmD1*-750\r\n"
  vol.get.should eq 25
end
