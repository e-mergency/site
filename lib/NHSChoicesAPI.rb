module NHSChoicesAPI
  
  @NHSAPIKEY = ''
  def getHospitalIDs
    json = get 'http://v1.syndication.nhschoices.nhs.uk/organisations/hospitals/identifiermappings'
    puts json.inspect
  end
  
  def get(url)
    Nestful.json_get url
  end

  def apikey
    return '?apikey=' + @NHSAPIKEY
  end
end