#
#   We're going to use VersionBox External API
#   It's designed to make our job easy in here.
#
#   @author:    Furkan Enes Apaydın (@feapaydin)
#   @company:   Loop Digital
#   @date:      2018
#


# GET Method
def vb_get(_endpoint, _params=nil)

    
    #Prepare final url
    url=CONFIG["API_BASE"] + _endpoint

    uri=URI(url)
    uri.query = URI.encode_www_form(_params) unless _params.nil?

    response=Net::HTTP.get_response(uri)
    
    #all of the VersionBox APIs works with json
    #hence we simply return response as json 
    if response.is_a?(Net::HTTPSuccess)
        
        #All done here
        return JSON.parse(response.body)

    else
        #if anything goes wrong with api response, 
        #   we return a custom response     
        return {status: false, error_code: :api_error, error_message: "Could not retrieve data from VersionBox API."}
    end


    # In case of any error
    rescue => e
        return {status: false, error_code: :exception, error_message: "An exception happened: #{e}"}
 


end
#end GET





