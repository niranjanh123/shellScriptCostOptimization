#!/bin/bash

set -x
set -e

JENKINS_HOME_DIR="/var/lib/jenkins/jobs"
s3_bucket="s3://log-jenkins/logs/"

DATE=$(date +%Y-%m-%d)

directory_Validation() {
    if [ -d "$JENKINS_HOME_DIR" ] && [ "$(ls -A "$JENKINS_HOME_DIR")" ]; then
        echo "Jenkins jobs directory exists and contains files."
    else
        echo "The Jenkins jobs directory does not exist or is empty."
        exit 1
    fi
}

check_AWSCLI() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed."
        exit 2
    fi
}

push_logs_to_s3() {
    for job in "$JENKINS_HOME_DIR/"*/; do
        job_name=$(basename "$job")
        echo "Processing job: $job_name"

        for build_dir in "$job/builds/"*/; do
            build_number=$(basename "$build_dir")
            log_file="$build_dir/log"

            if [ -f "$log_file" ]; then
                echo "Uploading log file: $log_file"
                aws s3 cp "$log_file" "$s3_bucket/$job_name/builds/$build_number.log" --only-show-errors || {
                    echo "Failed to upload $log_file to S3."
                    exit 1
                }
                echo "Uploaded $log_file to S3."
            else
                echo "No log file found for build: $build_number"
            fi
        done
    done
}

directory_Validation
check_AWSCLI
push_logs_to_s3

