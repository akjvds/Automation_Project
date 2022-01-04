timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket="upgrad-ankita"
myname=Ankita
sudo apt-get update -y

#Code to check if apache is installed or not if not then install it
REQUIRED_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

#Below code will check apache2 service is enabled or not, if not then enable it.
apache2_check="$(systemctl status apache2.service | grep Active | awk {'print $3'})"
if [ "${apache2_check}" = "(dead)" ]; then
	sudo systemctl enable apache2.service
fi

#Code to check if apache2 service is running or not if not running then run it
servstat=$(service apache2 status)
if [[ $servstat == *"active (running)"* ]]; then
  echo "process is running"
else echo "process is not running"
	sudo systemctl start apache2.service
fi

#Navigate to apache2 folder
cd /var/log/apache2

# create tar file
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log -C /tmp

#Copy tar file to S3 Bucket
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
