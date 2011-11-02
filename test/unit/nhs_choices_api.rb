require 'test_helper'
require_relative '../../lib/NHSChoicesApi'

class NHSChoicesAPITest < ActiveSupport::TestCase
  test "can build the scraper object" do
    scraper = NHSChoicesAPI::Scraper.new
    assert_not_nil(scraper)
    assert_instance_of(NHSChoicesAPI::Scraper, scraper)
  end

  test "grabbing hospital IDs produces an array" do
    scraper = NHSChoicesAPI::Scraper.new
    ids = scraper.get_hospital_ids
    assert_instance_of(Array, ids)
    assert(ids.include? "1960")
  end

  test "get hospital overview urls" do
    scraper = NHSChoicesAPI::Scraper.new
    overview_urls = scraper.get_hospital_overview_urls
    assert_instance_of(Hash, overview_urls)

    # Checking internal vals like this should be mocked
    assert(overview_urls.include? "71591")
    assert_equal overview_urls["71591"], "http://v1.syndication.nhschoices.nhs.uk/organisations/hospitals/71591/overview.xml?apikey=NOCRIYLM"
  end
end
