require 'nokogiri'
require 'open-uri'

module NHSChoicesAPI
  include Nokogiri

  NHSAPIKEY = 'NOCRIYLM'
  
  class Scraper
    @api_url = 'http://v1.syndication.nhschoices.nhs.uk/organisations/hospitals/'

    #def get_hospital_overviews
    #  overviews = {}
    #  ids = get_hospital_ids

    #   ids.each do |id|
    #    url = @api_url + id + '/overview.xml' + '?apikey=' + NHSChoicesAPI::NHSAPIKEY
    #    doc = Nokogiri::XML(open(url))
    #    hospital = {}
    #    hospital['name'] = doc.xpath('//s:overview/s:name')
    #    hospital['ods'] = doc.xpath('//s:overview/s:odsCode')
    #    overview[id] = hospital
    #    break if overviews.length > 10
    #  end
    #  overview
    #end

    # Get an array of hospital ids. Memoizes the result to @ID_ARRAY
    def get_hospital_ids
      @hospital_ids ||= Scraper.get_hospital_ids_from_server
    end

    # Scrapes the NHS Choices API for hospital ids
    def self.get_hospital_ids_from_server
      url = @api_url + 'identifiermappings.xhtml' + api_key
      doc = Nokogiri::HTML(open(url))
      id_arr = []
      doc.css('#identifierMappings tr td.id').each do |id|
        id_arr << id.content
      end
      return id_arr
    end

    # Returns a string for easy appending of the api key to api urls that are being built
    def self.api_key
      return '?apikey=' + NHSChoicesAPI::NHSAPIKEY
    end
  end
end
