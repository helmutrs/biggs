module Biggs
  class Formatter
    FIELDS = [:recipient, :street, :city, :region, :region_short, :postalcode, :country]

    def initialize(options = {})
      @blank_country_on = [options[:blank_country_on]].compact.flatten.map { |s| s.to_s.downcase }
    end

    def format(iso_code, values = {})
      # HACK: most of this method, honestly. I needed to get {{region_short}} working and
      #       bring this into compliance with countries v0.11.x.
      values.symbolize_keys! if values.respond_to?(:symbolize_keys!)

      format = Biggs::Format.find(iso_code)
      raise "Could not find country with code '#{iso_code}'." unless format && format.country

      format_string = (format.format_string || default_format_string(values[:region])).dup.to_s

      if values[:region_short] && !values[:region] && format_string.include?("{{region}}")
        region_code = values[:region_short]

        region = format.country.subdivisions[:region_short]
        raise "Could not find region/subdivision with code '#{region_code}'. " + 
              "To override, specify both :region and :region_short." unless region

        values[:region] = region[:name]
      elsif values[:region] && !values[:region_short] && format_string.include?("{{region_short}}")
        # FIXME: this is an iterative search over all names in the countries list. Not great, Bob.
        subdivision = format.country.subdivisions.find do |sub_kvp|
          sub_kvp[1]["name"] == values[:region] || sub_kvp[1]["names"].include?(values[:region])
        end
        raise "Could not find short_code" unless subdivision

        values[:region_short] = subdivision[0]
      end

      format_string = (format.format_string || default_format_string(values[:region])).dup.to_s
      country_name = blank_country_on.include?(format.iso_code) ? '' : format.country_name || format.iso_code

      (FIELDS - [:country]).each do |key|
        format_string.gsub!(/\{\{#{key}\}\}/, (values[key] || '').to_s)
      end
      format_string.gsub!(/\{\{country\}\}/, country_name)
      format_string.gsub(/\n$/, '')
    end

    attr_accessor :blank_country_on, :default_country_without_region, :default_country_with_region

    private

    def default_format_string(region)
      region && region != '' ?
        Biggs.country[default_country_with_region || 'us'].address_format :
        Biggs.country[default_country_without_region || 'fr'].address_format
    end
  end
end
