#!/bin/bash
# declare variables
# You can enable the log feature by uncommenting the next line, and line 50, 53, 71, and 74
# LOGFILE="/path/to/update.log" # the location of the log file
MAVENLOG="/path/to/maven.log" #Log any error that maven encountered
sourceDir="/path/to/sourceDir" # the target directory for downloading the jar file
serverDir="/path/to/serverDir" # the directory where the server files
# CHECK=true # check if update succeed (useless at the moment)

# Check if the user is in root
if (( $EUID != 0)); then
    echo "Please run the updater as root"
    exit
fi

echo "updating nukkit..."
cd $sourceDir
# git clone if Nukkit folder doesn't exist
if [ ! -d "$sourceDir/Nukkit" ];
    then
    git clone https://github.com/NukkitX/Nukkit.git
fi

cd Nukkit
# Update repository with git
git pull origin master
git submodule update --init

# Compile with Maven
echo "compiling..."
echo "$(date "+%m%d%Y %T") maven command started" >> $MAVENLOG 2>&1 
# Time stamp maven log and run maven package command
mvn clean package >> $MAVENLOG 2>&1
cd target

echo "updating nukkit, this might take a while..."
mv nukkit-1.0-SNAPSHOT.jar server.jar
cp server.jar $sourceDir
cd $sourceDir
cp server.jar $serverDir

# this is the algorithm of the build check
cd $sourceDir
MODIFYDATE=$(date -r server.jar +%m%d%Y)
DATE=$(date +%m%d%Y)
echo $MODIFYDATE
echo $DATE
if [ "$MODIFYDATE" -eq "$DATE" ]
    then
      #  echo "$(date "+%m%d%Y %T") : Update succeed." >> $LOGFILE 2>&1
        echo "Update succeed."
    else
      #  echo "$(date "+%m%d%Y %T") : Update failed." >> $LOGFILE 2>&1
        echo "Update failed."

	# Starting alternative method
	echo "using alternative method"
	cd $sourceDir
	wget -P $sourceDir \
	https://ci.nukkitx.com/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/nukkit-1.0-SNAPSHOT.jar
	mv nukkit-1.0-SNAPSHOT.jar server.jar
	cp server.jar $serverDir
	# initialize check 2
	cd $serverDir
	MODIFYDATEM2=$(date -r server.jar +%m%d%Y)
	echo $MODIFYDATEM2
	echo $DATE
	# This method check from $serverDir instead of $sourceDir
	if [ "$MODIFYDATEM2" -eq "$DATE" ]
    	    then
              #  echo "$(date "+%m%d%Y %T") : Method2 succeed." >> $LOGFILE 2>&1
                echo "Method2 succeed."
    	    else
	      #  echo "$(date "+%m%d%Y %T") : Method2 failed." >> $LOGFILE 2>&1
                echo "Method2 failed."
	fi
fi

# restart nukkit by killing the entire java process (its not the best method)
echo "update completed, restarting nukkit, this might take a while..."
pkill java
sleep 10
echo "restart completed"
echo "Attention: if you don't have an auto-restart script, you have to manually restart the server"


#====================IGNORE ANYTHING UNDER THIS LINE========================================================

# resources for future use
# if (( $CHECK == true)); then # This if statement check if build succeed
#    echo "$(date "+%m%d%Y %T") : Update succeed." >> $LOGFILE 2>&1
# else
#    echo "$(date "+%m%d%Y %T") : Update failed." >> $LOGFILE 2>&1
# fi
# echo "$(date "+%m%d%Y %T") : Update succeed." >> $LOGFILE 2>&1
# rm -r /home/ubuntu/Nukkit
# date -r server.jar +%m%d%Y

