require 'device_input/labels'

# :nocov:
module DeviceInput
  if RbConfig::CONFIG.fetch("MAJOR").to_i < 2
    raise "unsupported ruby version #{RbConfig::CONFIG['RUBY_VERSION_NAME']}"
  else
    RUBY23 = RbConfig::CONFIG.fetch("MINOR").to_i >= 3
  end

  unless RUBY23
    class Event
      def CODES.dig(*args)
        memo = self
        args.each { |a|
          memo = memo[a] rescue nil
          break unless memo
        }
        memo
      end
    end
  end
end
# :nocov:
