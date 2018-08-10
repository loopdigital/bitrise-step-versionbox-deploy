#
#
#   VersionBox Bitrise Workflow Step
#   @author:    Furkan Enes Apaydın (@feapaydin) 
#   @company:   Loop Digital
#   @date:      2018
#
#

#!/bin/bash
set -ex



#Absolute path of the project dir.
STEP_DIR=$( cd "$(dirname "$0")" ; pwd -P )



#Install gems
gem install json



#Execute the main.rb
e=$(ruby "${STEP_DIR}/app/main.rb" $vb_api_token $vb_app_key $vb_file_path "$vb_version_description" $vb_mark_live $vb_auto_publish $vb_description_from_commit $vb_cloned_repository_path)



#Finalize
r='^[0-9]+$'

if ! [[ $e  =~ $r ]]; then
    echo "An error occured while deploying to VersionBox: ${e}"
    exit 1
else
    echo "VersionBox Deployment Success."
    exit 0
fi





