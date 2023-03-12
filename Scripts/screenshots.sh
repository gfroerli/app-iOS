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
pro11="Pro11ScreenShots"
plus8="Plus8ScreenShots"

#sim=$pro14
#dim=1290x2796

#sim=$pro11
#dim=1242x2688

sim=$plus8
dim=1242x2208

operatorName="Gfrör.li"
timeStamp="2020-02-03T13:37q:00+00:00"
dataNetwork=wifi

# Remove existing files & reset simulators
echo -e "Removing existing files\n\n"
rm -rf $xcresultPath
rm -rf $outputFolderPath
xcrun simctl shutdown all

# Simulator setup
echo -e "Launching simulator\n\n"


xcrun simctl erase $sim
xcrun simctl boot $sim
xcrun simctl status_bar $sim override --time $timeStamp --dataNetwork $dataNetwork --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --operatorName $operatorName --batteryState discharging --batteryLevel 100


# Run screenshots
echo -e "Start taking screenshots\n\n"
xcodebuild test -project gfroerli.xcodeproj -scheme $schemeName -destination "platform=iOS Simulator,name=$sim"

# Find and Extract Screenshots using xcparse
echo -e "Extracting screenshots\n\n"
find $xcresultPath -maxdepth 1 -type d -exec xcparse screenshots --language {} "$outputFolderPath/" \;

# Rename extracted folders and images
# Folders
for langDir in $outputFolderPath/*; do
  base=$(basename $langDir)
    #Images
    echo -e "\n\nStart rename files for $langDir\n\n"
    for file in $langDir/*; do
      newName=${file%_*}
      newName2=${newName%_*}
      mv -v $file "$newName2.png"
      convert "$newName2.png" -resize $dim "$newName2.png"
      convert "$newName2.png" -alpha off "$newName2.png"
    done
done
xcrun simctl shutdown all
