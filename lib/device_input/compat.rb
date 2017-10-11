require 'device_input/labels'

# :nocov:
module DeviceInput
  begin
    require 'rbconfig/sizeof'
    SIZEOF = RbConfig::SIZEOF.dup
  rescue LoadError
    # ok, this is what MRI 2.3 has:
    SIZEOF = {"int"=>4, "short"=>2, "long"=>8, "long long"=>8, "__int128"=>16, "off_t"=>8, "void*"=>8, "float"=>4, "double"=>8, "time_t"=>8, "clock_t"=>8, "size_t"=>8, "ptrdiff_t"=>8, "int8_t"=>1, "uint8_t"=>1, "int16_t"=>2, "uint16_t"=>2, "int32_t"=>4, "uint32_t"=>4, "int64_t"=>8, "uint64_t"=>8, "int128_t"=>16, "uint128_t"=>16, "intptr_t"=>8, "uintptr_t"=>8, "ssize_t"=>8, "int_least8_t"=>1, "int_least16_t"=>2, "int_least32_t"=>4, "int_least64_t"=>8, "int_fast8_t"=>1, "int_fast16_t"=>8, "int_fast32_t"=>8, "int_fast64_t"=>8, "intmax_t"=>8, "sig_atomic_t"=>4, "wchar_t"=>4, "wint_t"=>4, "wctrans_t"=>8, "wctype_t"=>8, "_Bool"=>1, "long double"=>16, "float _Complex"=>8, "double _Complex"=>16, "long double _Complex"=>32, "__float128"=>16, "_Decimal32"=>4, "_Decimal64"=>8, "_Decimal128"=>16, "__float80"=>16}
  end

  if RbConfig::CONFIG.fetch("MAJOR").to_i < 2
    raise "unsupported ruby version #{RbConfig::CONFIG['RUBY_VERSION_NAME']}"
  else
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
