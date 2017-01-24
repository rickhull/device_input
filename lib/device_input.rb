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

    # these are just labels, not used internally
    TYPES = {
      0x00 => ['EV_SYN', 'Sync'],
      0x01 => ['EV_KEY', 'Key'],
      0x02 => ['EV_REL', 'Relative'],
      0x03 => ['EV_ABS', 'Absolute'],
      0x04 => ['EV_MSC', 'Misc'],
      0x05 => ['EV_SW',  'ToggleSwitch'],
      0x17 => ['EV_LED', 'LED'],
      0x18 => ['EV_SND', 'Sound'],
      0x20 => ['EV_REP', 'Repeat'],
      0x21 => ['EV_FF',  'ForceFeedback'],
      0x22 => ['EV_PWR', 'Power'],
      0x23 => ['EV_FF_STATUS', 'ForceFeedbackStatus'],
    }

    # convert Event::Data to a string
    def self.encode(data)
      data.values.pack(PACK)
    end

    # convert string to Event::Data
    def self.decode(binstr)
      Data.new *binstr.unpack(PACK)
    end

    # return an array from [raw ... pretty]
    def self.type_labels(type_code)
      TYPES[type_code] || ["UNK-#{type_code}"]
    end

    # return an array from [raw ... pretty]
    def self.code_labels(type_code, code_code)
      require 'device_input/codes'
      labels = DeviceInput::CODES.dig(type_code, code_code)
      if labels
        # not all labels have been converted to arrays yet
        labels.kind_of?(Enumerable) ? labels : [labels]
      else
        ["UNK-#{type_code}-#{code_code}"]
      end
    end

    NULL_DATA = Data.new(0, 0, 0, 0, 0)
    NULL_MSG = self.encode(NULL_DATA)
    BYTE_LENGTH = NULL_MSG.length

    attr_reader :data, :time, :type, :code

    def initialize(data)
      @data = data
      @time = Time.at(data.tv_sec, data.tv_usec)
      # take the raw label, closest to the metal
      @type = self.class.type_labels(data.type).first
      @code = self.class.code_labels(data.type, data.code).first
    end

    def value
      @data.value
    end

    def to_s
      [@type, @code, @data.value].join(':')
    end

    # show timestamp and use the last of the labels
    def pretty
      [@time.strftime("%Y-%m-%d %H:%M:%S.%L"),
       [self.class.type_labels(@data.type).last,
        self.class.code_labels(@data.type, @data.code).last,
        @data.value].join(':'),
      ].join(" ")
    end

    # don't use any labels
    def raw
      [@data.type, @data.code, @data.value].join(':')
    end

    # display fields in hex
    def bytes
      require 'rbconfig/sizeof'
      DEFINITION.inject('') { |memo, (field, type)|
        int = @data.send(field)
        width = RbConfig::SIZEOF.fetch(type)
        # memo + ("%#0.#{width * 2}x" % int) + " "
        memo + ("%0.#{width * 2}x" % int) + " "
      }
    end
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
