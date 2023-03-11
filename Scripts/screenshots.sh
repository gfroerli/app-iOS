#!/bin/bash

# Executing this file will create screenshots


set -euo pipefail

schemeName="gfroerli"
testPlanName="gfroerliScreenshots"


echo -e "Running screenshots for Gfrörli \n\n"

# Predefines
outputFolderPath="./Screenshots/"
xcresultPath="./DerivedData/gfroerli/Logs/Test"

pro14="Pro14ScreenShots"

simulators=( "$pro14" )

operatorName="Gfrör.li"
timeStamp="2020-02-03T13:37q:00+00:00"
dataNetwork=wifi

# Remove existing files & reset simulators
echo -e "Removing existing files\n\n"
rm -rf $xcresultPath
rm -rf $outputFolderPath
xcrun simctl shutdown all

# Simulator setup
echo -e "Launching simulators\n\n"

for sim in "${simulators[@]}"; do
  xcrun simctl erase $sim
  xcrun simctl boot $sim
  xcrun simctl status_bar $sim override --time $timeStamp --dataNetwork $dataNetwork --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --operatorName $operatorName --batteryState discharging --batteryLevel 100
done

# Run screenshots
echo -e "Start taking screenshots\n\n"
xcodebuild test -project gfroerli.xcodeproj -scheme $schemeName -destination "platform=iOS Simulator,name=$pro14"

# Find and Extract Screenshots using xcparse
echo -e "Extracting screenshots\n\n"
find $xcresultPath -maxdepth 1 -type d -exec xcparse screenshots --language {} "$outputFolderPath/" \;

# Rename extracted folders and images
# Folders
for file in $outputFolderPath/*; do

      newName=${file%_*}
      newName2=${newName%_*}
      mv -v $file "$newName2.png"
    
    
done
xcrun simctl shutdown all
