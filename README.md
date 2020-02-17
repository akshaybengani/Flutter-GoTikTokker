# GoTikTokker
Go Tik Tokker is a Fun Application designed to shoot and share your videos with the users using the app, You can like someones video and can unlike videos.

## Installation and How to use it
1. Since the app is in very very initial stage therefore I have not done any unit or integration testing at all so follow the instructions carefully The app dont provide registration functionality so signin with these credentials below

|        Email          |       Password        |
| --------------------- | --------------------- |
|   testuser1@gmail.com |     testuser          |
|   testuser2@gmail.com |     testuser          |
|   testuser3@gmail.com |     testuser          |
|   testuser4@gmail.com |     testuser          |

2. After Login You will encounter Feed Tab with bottom naviagtion, If you are looking at circular progress indicator for long then please visit to users tab or any other tab and then revisit it, There are some problems in loading the videocontroller in first attempt dont worry now it will work fine with no issues.
3. You can Create your own videos with the new tab a camera ui will open and there you can use all kinds of inbuilt camera features and record a video, after completion it will show the video in a container for preview and there you can play or pause video.
4. When you click on upload button the video file in the highest quality without any compression started uploading to firebase Storage.
5. When the upload complete it will show you "Upload Completed".
6. Now you can watch any of the video the API will fetch all videos info and randomly shuffles it and gives you a random video file.
7. You can like or unlike the video from the floating button over there.
8. The Video Player supports Play and Pause so when you tap on video it will pause and play the video, I have  used gesturedetector for this.
9. That's it for now.

## Application Features
1. The App Provides Video recording Preview and upload functionality
2. The App is designed with the aspect of Multi user with single/common Database apprach.
3. Users will get a Random video whenever they open the feed screen
4. You can Like and Play Pause the video by simply tapping on video.
5. Likes are calculated both by individual basis and total basis.
6. The App provides recording time with no limits currently.
7. The App use Provider Package for State Management, will shift it to Flutter_bloc once evalation completes.
8. Videos are stored in Firebase Storage and information is currently stored in Firebase Realtime Database.
9. Since the app is designed for multi user perspective so we can Login in the app, currently it dont provide registration screen, Soon will be adding registration.
10. The app uses FontAwesomeIcons pack for application icons throughout the app.

## Target Features
1. Use Flutterbloc; https://pub.dev/packages/flutter_bloc
2. Ability to upload videos of 10 seconds through a button on the bottom navigation bar
3. Feed screen to view videos with the ability to pause/play
4. Videos need to be stored on a server
5. Ability to like/share videos on the feed screen
6. Add simple auth through email/password with absolute information stored in Firebase; don’t need register
7. Use Font Awesome icons for the interface interactions; https://pub.dev/packages/font_awesome_flutter
8. Use Firebase Analytics; https://pub.dev/packages/firebase_analytics
9. Baseline caching that makes sure that the feed screen isn’t reloaded from the server on reopening the app every time; use local DB, Hive, etc.

## Incompleted Features in Actual build process.
1. Baseline caching that makes sure that the feed screen isn’t reloaded from the server on reopening the app every time; use local DB, Hive, etc.
* Since I can do the Text Database thing offline easily with the Sqflite but this is a video app and I tried to cache the whole video by storing locally and playing that way but I think there should be some better way to achieve this task, and due to Time and Resource limitations I couldn't  able to add the features yet.
* Since when opening the app you need to have an active internet connection to load the video.

2. Ability to share the videos.
* Currently the video controller is complicately designed and adding dynamic links to the app breaks lot of code, as such for now I didnt added this feature too, but yeah I can do that by some modifications.

## Packages Used
1.  firebase_analytics: ^5.0.11
2.  font_awesome_flutter: ^8.5.0
3.  provider: ^4.0.4
4.  firebase_auth: ^0.15.4
5.  connectivity: ^0.4.6+2
6.  data_connection_checker: ^0.3.4
7.  video_player: ^0.10.7
8.  image_picker: ^0.6.3+1
9.  firebase_storage: ^3.1.1
10. firebase_database: ^3.1.1

There are no external API's or Pakages I have used during the development all underlying packages are available in pub.dev

Thankyou for reading this document.
