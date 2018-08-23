# updateScriptForNukkit
This is a bash script that will allow you to update nukkitx to the newest release when running the script

If you have never installed nukkitx before, it will automatically download the nukkit jar file

# Auto update
Using Crontab or the watch command to run this script, will allow you to auto update nukkit periodically.

# Logging feature
There is a feature in this script, where you can write update log into a file, uncomment these lines to enable the feature:
- # LOGFILE="/path/to/update.log" # the location of the log file (please also update the directory)
- # echo "$(date "+%m%d%Y %T") : Update completed." >> $LOGFILE 2>&1

# Attention, before you run the script, you need to customize two things:
sourceDir="/path/to/sourceDirectory" (Change it to where you want the jar file to be downloaded to)
serverDir="/path/to/serverDirectory" (Change it to where you keep all your server files)



