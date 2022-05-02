require_relative 'helper.rb'

require 'device_input'

describe DeviceInput::Event do
  E = DeviceInput::Event

  describe "type_labels" do
    it "must return an array of strings" do
      dne = E.type_labels(:does_not_exist)
      expect(dne).must_be_instance_of(Array)
      expect(dne.first).must_be_instance_of(String)
      expect(dne.last).must_be_instance_of(String)

      # 0 is EV_SYN
      de = E.type_labels(0)
      expect(de).must_be_instance_of(Array)
      expect(de.first).must_be_instance_of(String)
      expect(de.last).must_be_instance_of(String)
    end
  end

  describe "code_labels" do
    it "must return an array of strings" do
      dne = E.code_labels(:does_not_exist, nil)
      expect(dne).must_be_instance_of(Array)
      expect(dne.first).must_be_instance_of(String)
      expect(dne.last).must_be_instance_of(String)

      # 0,0 = EV_SYN,SYN_REPORT
      de = E.code_labels(0, 0)
      expect(de).must_be_instance_of(Array)
      expect(de.first).must_be_instance_of(String)
      expect(de.last).must_be_instance_of(String)
    end
  end

  describe "encode" do
    it "must return a string" do
      expect(E.encode(E::NULL_DATA)).must_be_instance_of(String)
    end
  end

  describe "decode" do
    it "must return a Data (struct)" do
      expect(E.decode(E::NULL_MSG)).must_be_instance_of(E::Data)
    end
  end

  describe "new instance" do
    before do
      @event = E.new(E::NULL_DATA)
    end

    it "must have data" do
      expect(@event.data).must_be_instance_of(E::Data)
    end

    it "must have a timestamp" do
      expect(@event.time).must_be_instance_of(Time)
    end

    it "must have a type" do
      expect(@event.type).must_be_instance_of(String)
    end

    it "must have a code" do
      expect(@event.code).must_be_instance_of(String)
    end

    it "must have a value" do
      expect(@event.value).must_be_kind_of(Integer)
    end

    it "must have string representations" do
      [:to_s, :pretty, :raw, :hex].each { |meth|
        expect(@event.send(meth)).must_be_instance_of(String)
      }
    end
  end
end

describe DeviceInput do
  describe "read_loop" do
    before do
      @io = StringIO.new("\x00" * 64)
    end

    it "must read at least one message from an io with 64 bytes" do
      events = []
      DeviceInput.read_loop(@io) { |event|
        events << event
      }
      expect(events).wont_be_empty
      expect(events.first).must_be_instance_of(E)
    end
  end
end
