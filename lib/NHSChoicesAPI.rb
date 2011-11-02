require 'nokogiri'
require 'open-uri'

module NHSChoicesAPI
  include Nokogiri

  NHSAPIKEY = 'NOCRIYLM'
  API_URL = 'http://v1.syndication.nhschoices.nhs.uk/organisations/hospitals/'
  
  class Scraper
    # Get an array of location overview urls. Memoized after first call.
    def get_hospital_overview_urls
      @overview_urls ||= get_hospital_overview_urls_from_server
    end

    # Get an array of hospital ids. Memoizes the result to @hospital_ids
    def get_hospital_ids
      @hospital_ids ||= get_hospital_ids_from_server
    end

    # All methods past this point will not be publicly available
    private

    # Build up the URLs for gathering individual overviews for locations
    def get_hospital_overview_urls_from_server
      overview_urls = {}
      ids = get_hospital_ids

      ids.each do |id|
        url = NHSChoicesAPI::API_URL + id + '/overview.xml' + '?apikey=' + NHSChoicesAPI::NHSAPIKEY
        overview_urls[id] = url
      end

      overview_urls
    end

    # Scrapes the NHS Choices API for hospital ids
    def get_hospital_ids_from_server
      url = NHSChoicesAPI::API_URL + 'identifiermappings.xhtml' + api_key
      doc = Nokogiri::HTML(open(url))
      id_arr = []
      doc.css('#identifierMappings tr td.id').each do |id|
        id_arr << id.content
      end
      return id_arr
    end

    # Returns a string for easy appending of the api key to api urls that are being built
    def api_key
      return '?apikey=' + NHSChoicesAPI::NHSAPIKEY
    end
  end
end
