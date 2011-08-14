require 'nokogiri'
require 'open-uri'

module NHSChoicesAPI
  include Nokogiri

  NHSAPIKEY = ''
  
  class Scraper
    @api_url = 'http://v1.syndication.nhschoices.nhs.uk/organisations/hospitals/'

    def get_hospital_ids
      # Get hospital id list. Memoize the result to @ID_ARRAY
      @hospital_ids ||= Scraper.get_hospital_ids_from_server
    end

    def self.get_hospital_ids_from_server
      url = @api_url + 'identifiermappings.xhtml' + api_key
      doc = Nokogiri::HTML(open(url))
      id_arr = []
      doc.css('#identifierMappings tr td.id').each do |id|
        id_arr << id.content
      end
      return id_arr
    end
    
    def self.api_key
      return '?apikey=' + NHSChoicesAPI::NHSAPIKEY
    end
  end
end
