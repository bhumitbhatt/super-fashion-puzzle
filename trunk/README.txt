*** Legal Stuff ***
"Super Fashion Puzzle" and "SFP" copyright 2010 Ricardo Ruiz López. All trademarks and copyrights reserved.

The code contained within the 'src' folder (except cocos2d, facebook and objective resource) is licensed under the terms of the MIT license. You should read the entire license (filename "src/SFP_LICENSE.TXT" in this archive), so you understand your rights and what you can and cannot do with the source code from this release.

With the exception of sound_music_menu.mp3 (Touch of Light, released under Creative Commons), all of the Super Fashion Puzzle data files remain copyrighted and licensed Ricardo García Martínez under the original terms. See the Game license (filename "src/SFP_LICENSE.TXT in this archive) for more details. You cannot redistribute our data or data files from the original game. You can use our data for personal entertainment or educational purposes. Game data is contained within the "processed_resources" folder in this archive.

Please note that Super Fashion Puzzle is being released without any kind of support. Use at your own risk.
Super Fashion Puzzle uses several 3rd party libraries. Each one have its own legal notice. Refer to their documents and/or source code.


*** About Super Fashion Puzzle ***
Super Fashion Puzzle (SPF) is an iPhone game created by Ricardo Ruiz López (project, concept and development) and Ricardo García Martínez (art and its design) and some other help in our spare time. You can see credits scene inside the game. 
Official website: http://www.superfashionpuzzle.com/
iTunes link: http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=384946158&mt=8


*** Project Structure ***
README.txt: File you are reading right now.
docs: folder with state charts and class diagram. StarUML was used, but both diagrams were converted to PDF. Also changelogs.
libs: folder that contains Facebook and objective resource used by the game.
processed_resources: folder that contains art and sounds used by the game.
src: folder with project files and source code.

*** About the high scores web service ***
SFP uses a web service created using Ruby on Rails at www.superfashionpuzzle.com. It has two operations. Sending a score and getting high scores.
Sending a score uses basic authentication, and therefore SSL is used to encrypt user (game) password. Note that a username and password is required, but for obvious reasons, both have been removed from source code. File GameOverScene.m, method "tryToUploadScore".
Retrieving high scores do not use SSL and/or authentication, in fact, you could manually retrieve a XML or JSON file using your browser and going to www.superfashionpuzzle.com/highscores.xml or www.superfashionpuzzle.com/highscores.json, even retrieve them in HTML at www.superfashionpuzzle.com/highscores. Moreover, high scores are used in promotional website at www.superfashionpuzzle.com.


*** Software Design ***
All source code, comments, class diagram and state charts have been created in English.
State charts represents full program behavior. Class diagram represents only the most representative or important part of the program. 


*** Compiling and Deployment notes ***
Xcode version 3.2.5 and iOS SDK version 4.2 were used to create the latest version of SFP.
Used IDE and SDK can be found in file xcode_3.2.5_and_ios_sdk_4.2_final.dmg.
Deployment target was selected as version 3.0, therefore SFP works perfectly in iPhone OS 3.0 (and higher).
In order to create full and free version using the same code/project, two targets were created. Target "SFP" and another one called "SFP Free". They have different info.plist files (InfoFull.plist and InfoFree.plist) and icons. Moreover, a define called FREE_VERSION was used to create slightly different code. In target "SFP Free", "-DFREE_VERSION" value was used in "Other C flags" option.


*** About Free Version ***
Free and full version have some differences. Free version is the same as a demo version, in the meaning that game is not complete and have some banners for trying to sell the full version. As currently full version is for free, free version is not available in the App Store, as it makes no sense a demo version if full version is for free.
To see differences, just look for FREE_VERSION define word in project source code. Basically, free version have a banner in main menu screen and in game over screen (top right). If you touch it, the App Store will be launch with full version. Apart from that, after playing 3 levels, game goes directly to game over screen and a message box asks you if you want to buy full version. If you press "Yes", the App Store will be launched and full version shown.


*** 3rd Party Libraries or Source Code ***
Several 3rd party libraries or source code was used to create SFP.
Cocos2D. cocos2d-iphone-0.99.5.tar.gz. The game engine. Several versions were used. 0.99.5 was the latest one.
CCRadioMenu. By Ray Wenderlich. http://www.raywenderlich.com/414/how-to-create-buttons-in-cocos2d-simple-radio-and-toggle.
Facebook. facebook-facebook-iphone-sdk-1059eb6.zip. When a score is sent to my web service, in that moment, a random message is written in users wall (usually in English, but in Spanish if user's iPhone is in Spanish).
Objective Resource. Lastest version from GIT was used because current release fails if iOS when writing an object remotely.
Warning, as cocos2d and Objective Resource includes the same JSON code, one of them must be removed to avoid duplicated symbols (or code).


*** About provisioning profiles ****
SFP uses 6 provisioning profiles. 3 for each target, and there are 2 targets (full and free). Adhoc was used to test the game in different iPhones and iPods. Dev version was used by myself developing the game. Appstore was used to send the game to Apple through iTunnes Connect.
Provisioning profiles filenames:
Dev_Super_Fashion_Puzzle.mobileprovision
Adhoc_Super_Fashion_Puzzle.mobileprovision
Appstore_Super_Fashion_Puzzle.mobileprovision
Dev_Super_Fashion_Puzzle_Free.mobileprovision
Adhoc_Super_Fashion_Puzzle_Free.mobileprovision
Appstore_Super_Fashion_Puzzle_Free.mobileprovision
These 6 files have not been included because they are private data.


*** Contact Information ***
If you have any question, contact me at ricardo_ruiz_lopez AT yahoo DOT es. But remember, SFP is released without any kind of support. Use at your own risk.
