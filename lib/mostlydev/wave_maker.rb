# frozen_string_literal: true
# Copyright (c) 2019 Wojtek Grabski (mostlydev.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

module MostlyDev
  class WaveMaker
    attr_accessor :basename, :waves, :total_rows, :pay_pal_csv

    def initialize(params)
      pay_pal_csv = params[:csv]
      @waves = {}
      @total_rows = 0
      @pay_pal_csv = pay_pal_csv
      @basename = File.basename(@pay_pal_csv, '.csv')
    end

    def make_wave(currency)
      index = @waves[currency].count
      output_path = "#{basename}.#{currency.downcase}.#{index}.wave.csv"
      csv = CSV.open(output_path, 'wb')
      csv << %w[Date Description Amount]
      puts "... created #{output_path}"
      wave = { csv: csv, rows: 0 }

      @waves[currency] << wave
      wave
    end

    def get_wave(currency)
      @waves[currency] = [] unless @waves.key?(currency)
      wave = @waves[currency].last
      wave ||= make_wave(currency)
      wave = make_wave(currency) unless wave && wave[:rows] < 200
      wave
    end

    def make_waves!
      quote_chars = %w[" | ~ ^ & *]
      charset = detect_charset(@pay_pal_csv)
      csv = File.open(@pay_pal_csv).read
      if charset != 'utf-8'
        csv = csv.encode('utf-8', invalid: :replace, undef: :replace)
      end
      charset = detect_charset(@pay_pal_csv)
      CSV.parse(csv, headers: :first_row,
                     encoding: 'utf-8',
                     quote_char: quote_chars.shift) do |row|
        @row = row
        if currency_value.nil?
          puts 'ERROR: This is not a PayPal export!'
          break
        end

        currency = currency_value.downcase
        wave = get_wave(currency)

        date = row[0]
        name = name_value
        name = name ? name.gsub(/[^\w\ ]/, '') : nil
        description = [name, type_value].reject(&:nil?).join(' - ')
        amount = get_amount(gross_value)

        wave[:csv] << [date, description.to_s, amount]
        wave[:rows] += 1
        @total_rows += 1
        fee = get_amount(fee_value)
        unless fee == '0.00'
          wave[:csv] << [date, 'PayPal Fee', fee]
          wave[:rows] += 1
          @total_rows += 1
        end
      end
      puts "... outputted #{@total_rows} rows"
    end

    def get_amount(value)
      return '0.00' if value.nil? || value == '0' || value == '$-'

      amount = value.delete(',').delete('$')
      amount = '-' + amount.delete('(').delete(')') if amount.start_with?('(')
      '%.2f' % amount.to_f
    end

    def find_header(name)
      return name if @row.key?(name)

      key = @row.headers.find { |k| k.strip == name }
      key
    end

    %w[Gross Fee Name Currency Type].each do |header|
      attribute = header.downcase

      define_method "#{attribute}_key" do
        current = eval "@#{attribute}_key"
        return current unless current.nil?

        header = find_header(header)
        return nil if header.nil?

        eval "@#{attribute}_key='#{header}'"
        header
      end

      define_method "#{attribute}_value" do
        key = eval "#{attribute}_key"
        @row[key]
      end
    end

    def detect_charset(file_path)
      charset = if OS.mac?
                  `file -I #{file_path}`.strip.split('charset=').last
                elsif OS.linux?
                  `file -i #{file_path}`.strip.split('charset=').last
                end
    rescue StandardError => e
      Rails.logger.warn "Unable to determine charset of #{file_path}"
      Rails.logger.warn "Error: #{e.message}"
    end
  end
end
