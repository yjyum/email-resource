#!/bin/bash
set -ex

# Download concourse CLI
wget "http://$concourse_api_url:8080/api/v1/cli?arch=amd64&platform=linux" -O fly
chmod +x fly

# Target concourse API
./fly -t ccp login -u $concourse_username -p $concourse_password --concourse-url http://$concourse_api_url:8080

# Generate email
output_body_file=email-out/$output_body_file
output_subject_file=email-out/$output_subject_file

#./fly -t ccp watch -j $job > $output_subject_file
./fly -t ccp builds -j $job -c 1 > $output_body_file
