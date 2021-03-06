Interview app
============

### Purpose ###
Demostrate my ability to think through app design and development.

### App design and development philosophy ###
1.  **Focus on the problem**<br/>Having the ability to code a feature does not mean it belongs in the app.  App development is a cross between art and technology.  Knowing when to say **no** can be just as hard as implemenation. <br/>When coding a new feature I try to keep this mind, *"how does this solve the customer probem?"*  This may seem obvious but software bloat is still a prevlent problem in mobile apps.  In today's app the *hamburger menu* is evidence of an organization's inability to make a decision.<br/><br/>
2.  **Get the idea out of my head and into my hands as soon as possible**<br/>Rapid prototyping is a great way to validate value.  With today's tools and technology it is easy to build products on mobile.  The hard part is testing for the real customer value.<br/><br/>
3.  **Code wins arguments**<br />This goes in-hand with rapid prototyping.  Everyone has an opinion on how to solve a customer's problem.  The advantage of being a developer is, I can show you in a relatively short period of time.  I make it a point to kill the need to do a PowerPoint.<br/><br/>
4.  **Customers empathy should be the cornerstone of future features**<br/>As a developer this can be a difficult concept to embrace. Customer don't alway know what they want or how to solve the problem.  Through very *deliberate* analytics, I try to learn how and why the customer uses the app.  This is paired with in-person customer interviews.<br/><br/>
5.  **Love product development as much as coding**<br/>An app is just part of the solution.  Learning how to work with marketing, sales, customer support, (etc.) is as important as developing the app.  Success in the app store is not all about luck.<br/><br/>
6.  **App Analytics: Less is more**<br/>This is also a bit of art and science.  The key is undersating what you want to learn (measure) is to work backwards.  Meaning, identify the metric you want to move and measure it.  Most companys choose to measure everything and try to glean product direction out of it.  This often leads to indicision because you can make up any metric and justify.  Know what you want to learn and measure it.


App
===

###Name###
Café Ahora

###Vision Statement###
A quick and easy way to find coffee shops around at my current location.

###Base features###
*   Map View w/ pins (visual location on map)
*   Pins should indicate coffee shop name and any helpful selection information
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

## Tools
*   [XCode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) 6.3.2 (Coding)
*   [XCTest](https://developer.apple.com/videos/wwdc/2014/?id=414) (Unit and Functional tests)
*   [Sublime](http://www.sublimetext.com/) (non-coding related tasks, update Readme, etc.)
*   [Markable](http://markable.in/) (Markdown editor)
*   [GitHub Mac](https://mac.github.com/) (Managing source push to [GitHub](http://www.github.com))
*   [Glyphish](http://www.glyphish.com/) (Image assets)
*   [Cup Image (icon)]( https://openclipart.org/image/2400px/svg_to_png/169909/kitchen-coffee-cup.png) - (Attribution)

#### Development Websites/Resources
By no mean exhaustive

*   [iOS Playbook (Style Guide)](https://github.com/hyperoslo/iOS-playbook/blob/master/style-guidelines/ObjC.md) (Great resource for coding guidelines and best practices)
*   [Stack overflow](http://stackoverflow.com/questions/tagged/ios)
*   WWDC Videos - Great resource for diving deep into a single piece of the technology stack <br/>[2011](https://developer.apple.com/videos/wwdc/2011/)<br/>[2012](https://developer.apple.com/videos/wwdc/2012/)<br/>[2013](https://developer.apple.com/videos/wwdc/2013/)<br/>[2014](https://developer.apple.com/videos/wwdc/2014/)
*   [NSHipster](http://nshipster.com/) - Good and current articles
*   [Apple Documentation](https://developer.apple.com/library/ios/navigation/) - It is getting better
   
#### Favorite XCode Shortcut Keys (use these frequently):
*   Stop running - Command + .
*   Run on selected device - Command + R
*   Clean - Command + Shift + K
*   Build - Command + B
*   Test - Command + U
*   Apple Core/Foundation Header classes - Command + Left Click

## UI Wireframe

Here is a rough UI Wireframe of the design and navigation flow.

**(Version 1)**<br />
![Version 1 - UI Wireframe](https://raw.githubusercontent.com/TNuzzi/interview-app/master/images/wireframe.png)


**(Version 2)**<br />
![Version 2 - UI Wireframe](https://raw.githubusercontent.com/TNuzzi/interview-app/master/images/wireframe-v2.png)


### Design discussion ###
#### Here is a short video about my thoughts around the v1 design: ####

[![Design V1 video](http://img.youtube.com/vi/jrjm1C8bOQ8/0.jpg)](http://www.youtube.com/watch?v=jrjm1C8bOQ8)

#### Here is another video about why I changed the design (v2): ####

#### Reason's for the redesign ####
Understanding app design is important to a well functioning app.  For this app, I started down the path with my first design and soon realized it may not work for future functionality.  Meaning, I had visually designed it to be 2 seperate views in a single UIViewController.  If I wanted to expand on the functionality of either view I had to manage the state of which view (map or list) was being shown and all the supporting buttons/images/etc.  This lead me to redesign the app using a UITabbarController and make the list and map views each under there own UIViewControllers.

[![Design V2 video](http://img.youtube.com/vi/7hJ9BCB2nS4/0.jpg)](http://www.youtube.com/watch?v=7hJ9BCB2nS4)

## App Development (Coding)

### Project Structure ###
Quick video on the project structure and layout.  It is pretty straight forward.  Using the MVC paradigm to layout put the appropriate files in their respective groups.

[![Project Structure video](http://img.youtube.com/vi/d-Y2hOMeXAg/0.jpg)](http://www.youtube.com/watch?v=d-Y2hOMeXAg)

### Coding Overview Part 1 ###
This is a longer video where I go into detail about the current code implementation.  This is a first pass of the implementation.  I am using CoreLocation, MapView, Yelp Service call and Map Annotations.

[![Coding Overview Part 1 video](http://img.youtube.com/vi/cmRGba1d3sU/0.jpg)](http://www.youtube.com/watch?v=cmRGba1d3sU)

### Coding Refactor ###
Quick video describing the upcoming need to refactor.  Currently, the MapViewController is breaking the [Single Responsiblity principle](http://en.wikipedia.org/wiki/Single_responsibility_principle).  This principle states that a class should do 1 thing (e.g. *view* render a view, *model* only hold model data, etc.).  However the current implementation of the MapViewController does more then orchestrating between its view and model.

[![Code Refactor video](http://img.youtube.com/vi/6eciKB30wM4/0.jpg)](http://www.youtube.com/watch?v=6eciKB30wM4)

### Performance Issue ###
A quick video on a performance issue I encountered with loading remote images in table cells.  

The problem is with image caching and the way the code is retreiving the images. 

1.  The images are not cached.  Meaning, every time the cellForRow is called, the app has to go the remote server and retreive the image.
2.  The image is downloaded on the UI thread.

There are a couple of things I could do to fix this issue:

1.  Make the download aynchronious by using `NSOperationQueue`(to spawn background thread to download the images) or `NSURLSession`.  With the images downloaded write them to file or use something like `NSURLCache`.
2.  Read the images from a cache or file system.

Here is the offending code:
```
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [URL URLWithString: model.imageURL]];
    [cell.image setImage: [UIImage imageWithData: imageData]];
    
    NSData *ratingsData = [[NSData alloc] initWithContentsOfURL: [URL URLWithString: model.ratingsData]];
    [cell.ratingImage setImage: [UIImage imageWithData: imageData]];
```
To solve this problem I chose to use [SD Webimage](https://github.com/rs/SDWebImage).  It is available via CocoaPods.  SD Webimage uses extension to extends UIImage class and provides download (background) and image caching.

[![Performance Issue video](http://img.youtube.com/vi/rHlZk-OvUek/0.jpg)](http://www.youtube.com/watch?v=rHlZk-OvUek)