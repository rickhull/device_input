module DeviceInput
  class Event
    DEFINITION = {
      :tv_sec  => 'long',
      :tv_usec => 'long',
      :type    => 'uint16_t',
      :code    => 'uint16_t',
      :value   => 'int32_t',
    }
    PACK_MAP = {
      'long'     => 'l!',
      'uint16_t' => 'S',
      'int32_t'  => 'l',
    }
    PACK = DEFINITION.values.map { |v| PACK_MAP.fetch(v) }.join

    # this defines a class, i.e. class Data ...
    Data = Struct.new(*DEFINITION.keys)

    # convert Event::Data to a string
    def self.encode(data)
      data.values.pack(PACK)
    end

    # convert string to Event::Data
    def self.decode(binstr)
      Data.new *binstr.unpack(PACK)
    end

    def self.type_str(type_code)
      TYPES[type_code] || "UNK-#{type_code}"
    end

    def self.code_str(type_code, code_code)
      require 'device_input/events'
      DeviceInput::EVENTS.dig(type_code, code_code) ||
        "UNK-#{type_code}-#{code_code}"
    end

    NULL_DATA = Data.new(0, 0, 0, 0, 0)
    NULL_MSG = self.encode(NULL_DATA)

    attr_reader :data, :time, :type, :code

    def initialize(data)
      @data = data
      @time = Time.at(data.tv_sec, data.tv_usec)
      @type = self.class.type_str(data.type)
      @code = self.class.code_str(data.type, data.code)
      @value = data.value
    end

    def to_s
      [@type, @code, @value].join(':')
    end

    TYPES = {
      0 => 'Sync',
      1 => 'Key',
      2 => 'Relative',
      3 => 'Absolute',
      4 => 'Misc',
      17 => 'LED',
      18 => 'Sound',
      20 => 'Repeat',
      21 => 'ForceFeedback',
      22 => 'Power',
      23 => 'ForceFeedbackStatus',
    }

    BYTE_LENGTH = NULL_MSG.length
  end

  def self.read_from(filename)
    File.open(filename, 'r') { |f|
      loop {
        bytes = f.read(Event::BYTE_LENGTH)
        data = Event.decode(bytes)
        yield Event.new(data)
      }
    }
  end
end
