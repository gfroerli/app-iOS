
<p align="center">
    <img src="https://github.com/nliechti/gfroerli-ios/blob/main/Shared/Assets.xcassets/AppIcon.appiconset/AppIcon-ipad-83.5%402x.png" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/iOS-14.0+-brightgreen.svg" />
    <img src="https://img.shields.io/badge/Swift-5.0-brightgreen.svg" />
    <a href="https://twitter.com/coredump_ch">
        <img src="https://img.shields.io/badge/Contact-@coredump__ch-blue.svg?style=flat" alt="Twitter: @coredump_ch" />
    </a>
    <a href="https://twitter.com/makram_95">
        <img src="https://img.shields.io/badge/Contact-@makram__95-blue.svg?style=flat" alt="Twitter: @makram_95" />
    </a>
</p>

#This README and this Branch are deprecated and will be replaced once V3.0 is ready. Please refer to the respective branch to see the work-in-progress code.
Gfrör.li is a project that allows people to see local watertemperatures in real-time.
We use self-built sensors, that measure the local temperature every 15 minutes and send them to our back-end using the The Things Network. From there we request the aggregated data to present them to the user.

Currently the following locations are available:

- Rapperswil: HSR Badewiese

*New locations will be added shortly!*


The Gför.li iOS app is currently available to test via [TestFlight](https://testflight.apple.com/join/7GpwFq86) and will be released to the AppStore soon!


# App


## Architecture
The app is 100% written in Swift and only uses the frameworks provided by the standard iOS SDK. The UI-Framework used is SwiftUI 2, hence the lowest supported iOS version is 14.0. The communication to the backend is implemented via simple REST calls that return the data as JSON.


## UI
The app is intended to allow the user to allways see the current water temperature at their favorite locations. The structure of the app consists of multiple tabs, each of them having their own purpose. Of course the whole UI is available in darkmode as well.

<p align="center">
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Overview_EN.png" width="150"/>
    <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Favorites_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Lakeview_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/SensorView_EN.png" width="150"/>
  <img src="https://github.com/nliechti/gfroerli-ios/blob/main/AppstoreImages/Darkmode_EN.png" width="150" />
</p>

### Overview
The overview screen is the landing page of the app and presents some quick options to the user.

### Water Body Overview
The Waterbody Overview shows a map of the water body with markers containing the current temperature at the corresponding locations. It also lists all sensors that belong to it.

### Location Overview
This view presents the user the current temperature, all-time record values, a history-graph to see the temperature-profiles of the last day, week and month. Further, it shows the sensor on a small map-view that also allows the user to get the directions to the location with a single tap. At last, the user can see information about the sponsor of the sensor.

### Favorites
Here the user sees all the locations he marked as favorite in one place for quick access.

### Widgets
The user can select between two HomeScreen-Widgets, one simple with just the current temperature and one of a history graph with costumizable timeframe. They can be costumized using the Widget-Setting in the settings tab or by tap&hold directly onto them.

## Localization
The app is availble in these languages:
- English
- German
- Swiss-German
- French
- Italian
- Rumantsch

*If you find spelling or grammar mistakes, please contact us!*

## Privacy
Generally there is no userdata collected, except for:
- The email-adress and device info upon contacting us using the "Contact us" option in settings
- If allowed by the user, the crash and usage reports collected by iOS itself


## Contact
If you have some feedback and/or requests, including sponsoring or placing your own sensor, please contact us by [Email](mailto:appdev@coredump.ch) or via Twitter [@coredump_ch](https://twitter.com/coredump_ch) or [@makram_95](https://twitter.com/makram_95)! 
