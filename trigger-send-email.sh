#!/bin/bash
set -ex

# Download concourse CLI
wget "http://$concourse_api_url:8080/api/v1/cli?arch=amd64&platform=linux" -O fly
chmod +x fly

# Target concourse API
./fly -t ccp login -u $concourse_username -p $concourse_password --concourse-url http://$concourse_api_url:8080

# Trigger send-email job
./fly -t ccp trigger-job -j $trigger_job