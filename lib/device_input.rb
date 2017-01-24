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
      'long'     => 'L_',
      'uint16_t' => 'S',
      'int32_t'  => 'l',
    }
    PACK = DEFINITION.values.map { |v| PACK_MAP.fetch(v) }.join

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
      e = DeviceInput::EVENTS[type_code]
      if e and e[code_code]
        e[code_code]
      else
        "UNK-#{type_code}-#{code_code}"
      end
    end

    NULL_DATA = Data.new(0, 0, 0, 0, 0)
    NULL_MSG = self.encode(NULL_DATA)

    attr_reader :data, :time, :type, :code, :length

    def initialize(data)
      @data = data
      @time = Time.at(data.tv_sec, data.tv_usec)
      @type = self.class.type_str(data.type)
      @code = self.class.code_str(data.code)
      @value = data.value
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

  end
end
