require 'device_input/labels'
require 'device_input/compat'

module DeviceInput
  class Event
    DEFINITION = {
      :tv_sec  => 'long',     # 64 bits on 64-bit platforms
      :tv_usec => 'long',     # 32 bits on 32-bit platforms
      :type    => 'uint16_t',
      :code    => 'uint16_t',
      :value   => 'int32_t',
    }
    PACK_MAP = {
      'long'     => 'l!',     # platform-dependent
      'uint16_t' => 'S',
      'int32_t'  => 'l',
    }
    PACK = DEFINITION.values.map { |v| PACK_MAP.fetch(v) }.join

    # This defines a class, i.e. class Data ... with keys/ivars matching
    # DEFINITION. Data instances will hold a value for each of the keys.
    # Sorry for the name.  It refers literally to the struct-of-integers
    # representation we're creating here, every time we use the term `data`
    Data = Struct.new(*DEFINITION.keys)

    # convert Event::Data to a string
    def self.encode(data)
      data.values.pack(PACK)
    end

    # convert string to Event::Data
    def self.decode(binstr)
      Data.new(*binstr.unpack(PACK))
    end

    # return an array of equivalent labels, prettier toward the end
    def self.type_labels(type_val)
      TYPES[type_val] || ["UNK-#{type_val}"]
    end

    # return an array of equivalent labels, prettier toward the end
    def self.code_labels(type_val, code_val)
      CODES.dig(type_val, code_val) || ["UNK-#{type_val}-#{code_val}"]
    end

    NULL_DATA = Data.new(0, 0, 0, 0, 0)
    NULL_MSG = self.encode(NULL_DATA)
    BYTE_LENGTH = NULL_MSG.length

    attr_reader :data, :time, :type, :code

    def initialize(data)
      @data = data # sorry for the name.  it's a Data. data everywhere
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
    def ruby23_hex
      # :nocov:
      require 'rbconfig/sizeof'  # new in ruby 2.3
      DEFINITION.inject('') { |memo, (field, type)|
        int = @data.send(field)
        width = RbConfig::SIZEOF.fetch(type)
        # memo + ("%#0.#{width * 2}x" % int) + " "
        memo + ("%0.#{width * 2}x" % int) + " "
      }
      # :nocov:
    end

    alias_method :hex, RUBY23 ? :ruby23_hex : :to_s
  end

  def self.read_loop(io)
    loop {
      bytes = io.read(Event::BYTE_LENGTH)
      break unless (bytes and bytes.length == Event::BYTE_LENGTH)
      data = Event.decode(bytes)
      yield Event.new(data)
    }
  end
end
