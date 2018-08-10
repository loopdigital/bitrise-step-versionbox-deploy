#
#
#   App Helper Functions
#   @company:   Loop Digital Inc
#   @author:    Furkan Enes Apaydın (@feapaydin)
#   @date:      2018
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



def is_yes?(_str)
    return (_str=="true" || _str=="yes")
end



def file_push_versionbox

    mark_live=0
    publish=0

    mark_live=1 if is_yes?(CONFIG["MARK_LIVE"])
    publish=1   if is_yes?(CONFIG["AUTO_PUBLISH"])

    description=final_desc

    data= %x"curl -F 'file=@#{CONFIG["FILE_PATH"]}' -F app_key=#{CONFIG["APP_KEY"]} -F api_token=#{CONFIG["API_TOKEN"]} -F version_description='#{description}' -F mark_live=#{mark_live} -F publish=#{publish} #{CONFIG["API_BASE"]}UploadVersion "

    return JSON.parse data
end
#end file_push_versionbox





def final_desc

    #Return description from input if user wants to
    return CONFIG["VERSION_DESCRIPTION"] unless is_yes?(CONFIG["DESC_FROM_COMMIT"])


    #Get description from commits
    path=CONFIG["REPO_PATH"]
    desc=:not_found

    #Check if path is a git repo
    check=%x"cd #{path} && git rev-parse --is-inside-work-tree"
    check.gsub!("\n","")
    return nil unless check=="true"


    #Get repo tags
    tags=%x"cd #{path} && git tag -l"
    tags=tags.split("\n")
    tags=tags.reverse

  
    if tags.size<=1
        #If there is one or none tag, get all commits
        commits=%x"cd #{path} && git log --pretty=format:'%s'"
    else
        #If there are 2 or more tags, get the commits between them 
        latest_tag=tags[0]
        before_tag=tags[1]

        commits=%x"cd #{path} && git log #{latest_tag}...#{before_tag} --pretty=format:'%s'"
    end


    desc=commits


    #return
    desc
    

end
#end final_desc







