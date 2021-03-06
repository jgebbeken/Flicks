# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

Note: I just realized (1/30/2016) that I was pushing changes with my other username instead of my school username that I use only for my university. Not sure how to fix it and I am afraid of breaking my github settings in Xcode.

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] If poster image is not available then a no image placeholder will take its place.
- [x] UIView that shows so that the no Network view and button will notify the user if the network connect gather information. 
- [x] Search bar disappears from view if the network is down and will reappear if it's available again.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:



![walkthroughvideo3](https://cloud.githubusercontent.com/assets/14221032/12700412/cc36c2ba-c79e-11e5-8d16-91c741819dad.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

One challenge I was having is how to interact with a label to act as a button once it was displayed on screen. My no network label will appear as a subview once it detects it cannot obtain any data from the net. Having it set to allow interaction with it didn't give me any results. It's only when I had a long press gesture that it did.

## License

    Copyright [2016] [Josh Gebbeken]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    
##    
    
    
# Project 2 - *extension of the Flicks application*

**Flicks** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **13** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view movie details by tapping on a cell.
- [x] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [x] Customize the selection effect of the cell. - Background color for the collection cell is there but I'm not sure if the image is blocking the cell background since the image fills the entire size of the cell or what. However, the code is there for when the cell is selected and deselected.

The following **optional** features are implemented:

- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Collection View instead of the table view. I didn't add it in the first week but did it this time.
- [x] Extended color functionality to allow color hex codes for the tab bar and navigation bar in the appdelegate file.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Maybe providing ways add the searchbar into the navigation bar. I was able to do this only in the tableView but not in a collection view.
2. Using other SwiftyJSON like swifty since I did not implement that on my movie app.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![walkthrough4](https://cloud.githubusercontent.com/assets/14221032/12871330/e021505e-cd31-11e5-9e9a-5d42af7bff66.gif)

For a higher resolution animated gif please check out the link below. I had to cut back on the animated image because it was too big for github.

 [higher resolution image](http://i.imgur.com/mRXUg8m.gif)



GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [Josh Gebbeken]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

