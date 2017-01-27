require 'simplecov'

class SimpleCov::Formatter::TextFormatter
  FILENAME = 'metrics/coverage.txt'

  def format(result)
    tot = result.files
    rpt = ["Coverage: %0.1f%%" % tot.covered_percent,
           "Coverage strength: %0.2f" % tot.covered_strength,
           "Lines Covered: %i / %i" % [tot.covered_lines, tot.lines_of_code],
           "Missed, Never, Skipped: %i, %i, %i" % [tot.missed_lines,
                                                   tot.never_lines,
                                                   tot.skipped_lines],
           result.files.map { |sfile|
             "%i%%\t%s" % [sfile.covered_percent, sfile.filename]
           }.join("\n"),
          ].join("\n")
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
