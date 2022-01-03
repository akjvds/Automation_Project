# Automation_Project
This project will check the apache2 service is up and running or not, it will also check the its enabled or not if its not enabled then script will enable apache service on boot level.

Post above check sript will check the available error and access logs for apache2 and script will archive(tar) the logs on /tmp folder and then copy them to the s3 bucket.
