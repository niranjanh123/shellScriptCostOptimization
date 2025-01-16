# ShellScript Usecase

This shell script automates the process of backing up Jenkins log files to an S3 bucket, with the goal of freeing up space on the local file system. The script performs the following tasks:

1. Set Up Environment
JENKINS_HOME_DIR: Defines the path to the Jenkins job data directory (/var/lib/jenkins/jobs).
s3_bucket: Specifies the S3 bucket where the log files will be uploaded (s3://log-jenkins/logs/).
DATE: Stores the current date in YYYY-MM-DD format, which could be used to filter logs based on modification date.

2. Directory Validation (directory_Validation function)
Checks if the Jenkins jobs directory (/var/lib/jenkins/jobs) exists and is not empty.
If the directory does not exist or is empty, the script outputs an error message and exits.

3. AWS CLI Check (check_AWSCLI function)
Verifies if the AWS CLI is installed and available on the system.
If AWS CLI is not installed, the script will output an error message and exit.

4. Log File Transfer to S3 (push_logs_to_s3 function)
Iterates over each job directory inside $JENKINS_HOME_DIR.
For each job, it checks its builds directory for log files.
If a log file exists, it uploads the log file to the specified S3 bucket with a path format of s3://log-jenkins/logs/<job_name>/builds/<build_number>.log.
If a log file does not exist for a particular build, it logs a message but continues.
If any log upload fails, the script will output an error message and stop.

5. Execution Flow
The script first calls the directory_Validation function to confirm that the Jenkins job directory is valid.
Then, it calls the check_AWSCLI function to ensure AWS CLI is installed.
Finally, the script proceeds to the push_logs_to_s3 function to upload all the valid log files to the S3 bucket.

Key Features:
1. Error handling: The script ensures that it exits with appropriate error messages if any issue arises during validation or file transfer.
2. Efficiency: It processes each Jenkins job and its builds, uploading logs if present, and skips builds without log files.
3. Logging: During execution, the script outputs the status of each job and build, providing feedback to the user.
