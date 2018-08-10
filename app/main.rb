#
#
#   VersionBox Bitrise Workflow Step
#   @author:    Furkan Enes Apaydın (@feapaydin) 
#   @company:   Loop Digital
#   @date:      2018
#
#

require 'json'
require 'net/http'

require_relative 'lib/api'
require_relative 'lib/helpers'


# Generate Config
#   Any data under config.json will be loaded
#   Also we will retrieve bitrise variables inside CONFIG
CONFIG=JSON.parse(File.read(__dir__+"/config.json"))
CONFIG["API_TOKEN"]=ARGV[0]
CONFIG["APP_KEY"]=ARGV[1]
CONFIG["FILE_PATH"]=ARGV[2]
CONFIG["VERSION_DESCRIPTION"]=ARGV[3]
CONFIG["MARK_LIVE"]=ARGV[4]
CONFIG["AUTO_PUBLISH"]=ARGV[5]





#Fetch app details from API
data=vb_get(
    "ApplicationDetails",
    {
        api_token: CONFIG["API_TOKEN"], 
        app_key: CONFIG["APP_KEY"]
    }
)

#Kill if any error occur
unless data["status"]
    p "ERROR: #{data["error_message"]}"
    return data["error_code"]
end

#We have the app data!
application=data["data"]["application"]


#Check file
check_status=check_file CONFIG["FILE_PATH"]
return check_status unless check_status==true


#Upload the file
upload=file_push_versionbox

#Catch any errors on upload
unless upload["status"]
    p "ERROR: #{upload["error_message"]}"
    return upload["error_code"]
end




#Everything is success <3
p 0



