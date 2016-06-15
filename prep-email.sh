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

IFS=',' read -r -a JOBS <<< "$pipeline_jobs"
state="Success"

echo -e "\nResult:\n" >> $output_body_file

for job in "${JOBS[@]}"; do
	if ./fly -t ccp watch -j $pipeline/$job; then
		./fly -t ccp builds -j $pipeline/$job -c 1 >> $output_body_file
	else
		./fly -t ccp builds -j $pipeline/$job -c 1 >> $output_body_file
		state="Failure"
		break;
	fi
done

echo -e "\nConfiguration:\n" >> $output_body_file
./fly -t ccp gp -p $pipeline >> $output_body_file

#./fly -t ccp watch -j $job > $output_subject_file
# ./fly -t ccp builds -j $job -c 1 > $output_body_file

echo $state > $output_subject_file
# echo "see http://10.146.63.15:8080/pipelines/ for details" > $output_body_file