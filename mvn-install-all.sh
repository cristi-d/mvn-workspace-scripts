#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Expects an ordered list of mvn projects to install"
	echo "Usage: ./$0 <mvn-project-1> [<mvn-project-2>, ...]"
	exit 0;
fi


# Expects:
# $1	-	mvn project dir
# $2	-	output file
function mvnInstall {
	cd $1

	mvn clean install > $2
	
	echo $?

	cd ../
}

outputFile=".$0.output";

for mvnProject in $@; do
	echo "[INFO] Installing project $mvnProject"
	
	retVal="$(mvnInstall $mvnProject $outputFile)"
	if [ $retVal -ne 0 ]; then
		echo " [ERROR] Failed while installing $mvnProject. Aborting"
		echo -n "> Press 'l' to show execution log or hit Enter to dismiss: "
		read showLog

		if [ "$showLog" == "l" ]; then
			cat $outputFile | less
		fi

		rm $outputFile
		exit 1;
	fi
done

echo "[INFO] Successful installed the following Maven projects: $@"

rm $outputFile

exit 0;
