#
#
#   App Helper Functions
#
#


def check_file(_path)

    if _path.nil?
        p "ERROR: Invalid file path."
        return :invalid_file_path
    end
    

    #Check if ipa/apk exists on the given path
    unless File.exists?(_path)
        p "ERROR: Builded file cannot be found at given path."
        return :file_not_found
    end


    #Check if file extension is correct
    extension=File.extname _path

    if extension!=".apk" && extension!=".ipa"
        p "ERROR: Incorrect file extension."
        return :invalid_extension
    end


    true

end
#end check_file




def file_push_versionbox(_path, _app)

    data= %x"curl -F 'file=@#{_path}' -F app_key=#{CONFIG["APP_KEY"]} -F api_token=#{CONFIG["API_TOKEN"]} -F version_description=#{CONFIG["VERSION_DESCRIPTION"]} #{CONFIG["API_BASE"]}UploadVersion "

    return JSON.parse data
end
#end file_push_versionbox







