#!/bin/bash
# declare variables
# You can enable the log feature by uncommenting the next line, and the last line
# LOGFILE="/path/to/update.log" # the location of the log file
sourceDir="/path/to/sourceDiretory"
serverDir="/path/to/serverDirectory"
# Check if the user is in root
if (( $EUID != 0)); then
    echo "Please run the updater as root"
    exit
fi
echo "downloading nukkit..."
wget -q -P $sourceDir \
https://ci.nukkitx.com/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/nukkit-1.0-SNAPSHOT.jar
sleep 5
echo "updating nukkit, this might take a while..."
# cd /home/max/2b2tmcpe_dev/nukkitTestSrvr | rm server.jar
sleep 5
cd $sourceDir
sleep 5
mv nukkit-1.0-SNAPSHOT.jar server.jar
sleep 5
cp server.jar $serverDir
echo "update completed, restarting nukkit, this might take a while..."
pkill java
sleep 10
echo "restart completed"
echo "Attention: if you don't have an auto-restart script, you have to manually restart the server"
# Write log into the log file, uncomment the next line to enable logging feature
# echo "$(date "+%m%d%Y %T") : Update completed." >> $LOGFILE 2>&1


