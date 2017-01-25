require 'minitest/autorun'
require 'device_input'

describe DeviceInput::Event do
  E = DeviceInput::Event

  describe "type_labels" do
    it "must return an array of strings" do
      dne = E.type_labels(:does_not_exist)
      dne.must_be_instance_of(Array)
      dne.first.must_be_instance_of(String)
      dne.last.must_be_instance_of(String)

      # 0 is EV_SYN
      de = E.type_labels(0)
      de.must_be_instance_of(Array)
      de.first.must_be_instance_of(String)
      de.last.must_be_instance_of(String)
    end
  end

  describe "code_labels" do
    it "must return an array of strings" do
      dne = E.code_labels(:does_not_exist, nil)
      dne.must_be_instance_of(Array)
      dne.first.must_be_instance_of(String)
      dne.last.must_be_instance_of(String)

      # 0,0 = EV_SYN,SYN_REPORT
      de = E.code_labels(0, 0)
      de.must_be_instance_of(Array)
      de.first.must_be_instance_of(String)
      de.last.must_be_instance_of(String)
    end
  end

  describe "new instance" do
    before do
      @event = E.new(E::NULL_DATA)
    end

    it "must have data" do
      @event.data.must_be_instance_of(E::Data)
    end

    it "must have a timestamp" do
      @event.time.must_be_instance_of(Time)
    end

    it "must have a type" do
      @event.type.must_be_instance_of(String)
    end

    it "must have a code" do
      @event.code.must_be_instance_of(String)
    end

    it "must have a value" do
      @event.value.must_be_kind_of(Integer)
    end

    it "must have string representations" do
      [:to_s, :pretty, :raw, :hex].each { |meth|
        @event.send(meth).must_be_instance_of(String)
      }
    end
  end
end
