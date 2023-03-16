if ENV['CODE_COVERAGE'] and
  !%w[false no].include?(ENV['CODE_COVERAGE'].downcase)

  require 'simplecov'
  require 'simplecov_json_formatter'

  class SimpleCov::Formatter::TextFormatter
    FILENAME = 'metrics/coverage'

    def format(result)
      tot = result.files
      rpt = ["Coverage: %0.1f%%" % tot.covered_percent,
             "Strength: %0.2f" % tot.covered_strength,
             "   Lines: %i" % tot.lines_of_code,
             " Covered: %i" % tot.covered_lines,
             "     N/A: %i" % tot.never_lines,
            ]
      if tot.missed_lines > 0
        rpt << "Missed: %i" % tot.missed_lines
      end
      if tot.skipped_lines > 0
        rpt << "Skipped: %i" % tot.skipped_lines
      end
      rpt << result.files.map { |sfile|
        "%i%% (%i/%i)\t%s" % [sfile.covered_percent,
                              sfile.covered_lines.length,
                              sfile.lines_of_code,
                              sfile.filename]
      }.join("\n")
      rpt = rpt.join("\n")

      puts
      puts rpt
      if File.writable?(FILENAME)
        File.open(FILENAME, 'w') { |f|
          f.write(rpt + "\n")
        }
        puts "wrote #{FILENAME}"
      end
    end
  end

  SimpleCov.formatters = [
    SimpleCov::Formatter::TextFormatter,
    SimpleCov::Formatter::JSONFormatter,
  ]

  SimpleCov.start
end
