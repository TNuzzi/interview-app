#Interview app#

###App###
Café Ahora

###Vision Statement###
A quick and easy way to find coffee shops around at my current location.

###Base features###
*   Map View w/ pins (visual location on map)
*   Pins should indicate shop name and any helpful selection information
*   List View with Search
*   Details about the coffee shop (name, location, etc)


###Nice to have###
*   Single button press to call
*   Saved favorites
*   [Routes to selected coffee shop from current location](https://developer.apple.com/library/prerelease/ios/documentation/MapKit/Reference/MKMapItem_class/index.html)
*   Share coffee shops (favorites) with social networks
*   Cached version of data locally (faster start up)
    *   If location has not changed read and use a local copy of data
    *   Possibly fetch a “fresher” version of data while showing last version
*   Ability to filter results
    *   Variable distance (car vs walking)
    *   By open hours (time and week day) 
    *   Ratings
*   Calendar integration
    *   Ability to invite friends at a future date; invite would include location
*   Include coffee shop menu items
*   Save coffee shop info to contact list
*   Profile information

###Technology Details (for Base Features)###
*   Use Nav Controller as primary means of navigation
*   Autolayout for device agnostic layout
*   NSUserDefaults to save the last location detected
*   CoreLocation to get long/lat of users current location
    *   For this app the search radius will be 4 miles (hard coded)
*   MKMapView for map view
    *   Pins on the with Annotations (show name, rating, loc when annotation pin tapped)
    *   Make Annotations clickable to detail view
*   Use TableView for list of coffee shops
    *   Row data will be each coffee shop
*   Implement a simple name search for table
*   Use segment control to toggle between map and list views
*   Use Toolbar to show progress of getting supporting data

*Still investigating data provider*

*   Use AFNetworking to make calls to Yelp** for data
<br/> -- or --
*   Use foursquare iOS SDK to get supporting data

** Yelp provides a bit more data but does not have a iOS SDK

**NOTE** I am not going to detail out the "nice to have" features.  Feel free to ask if you want more details on how I would implement a particular one.

## UI Wireframe

Here is a rough UI Wireframe of how the app will look and navigation flow.


![UI Wireframe](https://raw.githubusercontent.com/TNuzzi/interview-app/master/images/wireframe.png)