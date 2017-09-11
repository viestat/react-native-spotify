# React Native Spotify Module (IOS) 


## Intro
A native module that allows you to use the Spotify SDK API (IOS [beta 25](https://github.com/spotify/ios-sdk/releases/tag/beta-25)) with JavaScript through react-native.

___

## Overview

* [Set-up](#set-up)
* [How to use](#how-to-use)
* [Exposed API](#exposed-api)
  * [Auth](#auth)
  * [SPTAudioStreamingController Class](#sptaudiostreamingcontroller-class)
  * [SPTSearch Class](#sptsearch-class)
* [Demo](#demo) 

___

## Set-up:

### Using npm

>Recommended

1. Use `npm install react-native-spotify` from the directory of your project in your command line.

2. Download the Spotify IOS SDK beta 25 [here](https://github.com/spotify/ios-sdk/releases/tag/beta-25) and unzip it, you will find 3 files with the `.framework` extension.

3. Open your react native project in Xcode and drag the 3 unzipped `.framework` files (`SpotifyAudioPlayback`, `SpotifyAuthentication`, `SpotifyMetadata`) into the `Frameworks` group in your Xcode project (create the group if it doesn’t already exist). In the import dialog, tick the box for **Copy items into destinations group folder** (or **Destination: Copy items if needed**).

4. Please follow the instructions on the **"Creating Your Client ID, Secret and Callback URI"** and **"Setting Up Your Build Environment"** sections of the [*Spotify iOS SDK Tutorial*](https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/) 
>**Important Note!** When adding frameworks to the list in the "**Link Binary With Libraries**" section you will need to add `WebKit.framework` in addition to those mentioned in the tutorial.

5. Go to `node-modules/react-native-spotify/` and copy the following files to the `ios` directory of your project:
  * `SpotifyLoginViewController.m`
  * `SpotifyLoginViewController.h`
  * `SpotifyAuth.m`
  * `SpotifyAuth.h`

___

### Using git
1. Fork and clone the repo.

2. Download the Spotify IOS SDK beta 17 [here](https://github.com/spotify/ios-sdk/releases/tag/beta-17) and unzip it.

3. Open your react native project in Xcode and drag the 3 unzipped `.framework` files (`SpotifyAudioPlayback`, `SpotifyAuthentication`, `SpotifyMetadata`) into the `Frameworks` group in your Xcode project (create the group if it doesn’t already exist). In the import dialog, tick the box for **Copy items into destinations group folder** (or **Destination: Copy items if needed**).

4. Please follow the instructions on the **"Creating Your Client ID, Secret and Callback URI"** and **"Setting Up Your Build Environment"** sections of the [*Spotify iOS SDK Tutorial*](https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/) 
>**Important Note!** When adding frameworks to the list in the "**Link Binary With Libraries**" section you wll need to add `WebKit.framework` in addition to those mentioned in the tutorial.

5. From this project directory, go to `react-native-spotify/spotifyModule/ios` and copy the following files to the `ios` directory of your project:
  * `SpotifyLoginViewController.m`
  * `SpotifyLoginViewController.h`
  * `SpotifyAuth.m`
  * `SpotifyAuth.h`

___

## How to use:
```javascript
//You need to import NativeModules to your view
import { NativeModules } from 'react-native';

//Assign our module from NativeModules and assign it to a variable
var SpotifyModule = NativeModules.SpotifyModule;

class yourComponent extends Component {
  //Some code ...
  someMethod(){
    //You need this to Auth a user, without it you cant use any method!
    SpotifyModule.setClientID('Your ClientId','Your redirectURL', ['streaming'], (error)=>{
        if(error){
          //handle error
        } else {
          //handle success
        }
      });
  }
}
```

>**Important Note!** Take a look to the demo app icluded in the github repo for a more concise example.

___


## Exposed API:

### Auth:

**initWithCredentials**

> **You need this to Auth a user, without it you cant use any other methods!**

Set your Client ID, Redirect URL, Scopes and **start the auth process**


| Parameter |description|
| ------ |:-------------------------------|
|Client ID|`(String)` The client ID of your [registered Spotify app](https://developer.spotify.com/my-applications/#!/applications)|
|Redirect URL|`(String)` The Redirect URL of your [registered Spotify app](https://developer.spotify.com/my-applications/#!/applications)|
|Scopes|`(Array)` list of scopes of your app, [see here](https://developer.spotify.com/web-api/using-scopes/)  |
|Callback|`(Function)`a callback to handle the login success/error|

Example:

`SpotifyModule.initWithCredentials('your-clientID','your-redirectURL',['streaming',...],(error)=>{console.log(error)});`

---

## SPTAudioStreamingController Class:

### *Properties:*

**initialized**

Returns true when SPTAudioStreamingController is initialized, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.initialized((res)=>{console.log(res);});`

---

**[loggedIn](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/loggedIn)**

Returns true if the receiver is logged into the Spotify service, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.loggedIn((res)=>{console.log(res);});`

---

**[volume](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/volume)**

Returns the volume


| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.volume((res)=>{console.log(res);});`

---

**metadata**
Returns the Metadata for the currently playing context


| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.metadata((res)=>{console.log(res);});`

---

**playbackState**
> Review: Currently returns callback with info about `isPlaying`
Returns the players current state in an object with the following keys: 

```
isPlaying: (Boolean),
isRepeating: (Boolean),
isShuffling: (Boolean),
isActiveDevice: (Boolean),
position: (Number)
```

| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.playbackState((res)=>{console.log(res);});`

---

**targetBitrate**
Returns the current streaming bitrate the receiver is using


| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback to handle the response|

Example:

`SpotifyModule.targetBitrate((res)=>{console.log(res);});`

---

### *Methods:*

**[-logout:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/logout:)**

Logout from Spotify

| Parameter |description|
| ------ |:-------------------------------|
|N/A|N/A|

Example:

`SpotifyModule.logout();`

---

**[-setVolume:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setVolume:callback:)**

Set playback volume to the given level. Volume is a value between `0.0` and `1.0`.

| Parameter |description|
| ------ |:-------------------------------|
|volume  |`(Number)`The volume to change to, value between `0.0` and `1.0`|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.setVolume(0.8,(error)=>{console.log(error);});`

---


**[-setTargetBitrate:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setTargetBitrate:callback:)**

Set the target streaming bitrate. `0` for low, `1` for normal and `2` for high

| Parameter |description|
| ------ |:-------------------------------|
|bitrate|`(Number)`The bitrate to target            |
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.setTargetBitrate(2,(error)=>{console.log(error);});`

---

**-seekTo:callback:**

Seek playback to a given location in the current track (in secconds).

| Parameter |description|
| ------ |:-------------------------------|
| offset |`(Number)`The time to seek to|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.seekToOffset(110,(error)=>{console.log(error);});`

---

**-playSpotifyURI:startingWithIndex:startingWithPosition:callback:**
Play a Spotify URI.
Play a list of Spotify URIs.(at most 100 tracks).`SPTPlayOptions` containing extra information about the play request such as which track to play and from which starting position within the track.

| Parameter |description|
| ------ |:-------------------------------|
| spotifyUri |`(String)` a valid spotify Uri|
| index |`(Number)` The index of an item that should be played first, e.g. 0 - for the very first track in the playlist or a single track|
| position |`(Number)` starting position for playback in seconds|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.playSpotifyURI("spotify:track:12x8gQl2UYcQ3tizSfoPbZ", 0, 0.0,(error)=>{console.log(error)});`

---

**-queueSpotifyURI:callback:**
 
 Queue a Spotify URI.

| Parameter |description|
| ------ |:-------------------------------|
| spotifyUri |`(String)` the Spotify URI to queue|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.queueSpotifyURI("spotify:track:6HxIUB3fLRS8W3LfYPE8tP", (error)=>{console.log(error)});`

---

**[-setIsPlaying:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setIsPlaying:callback:)**

Set the "playing" status of the receiver.

| Parameter |description|
| ------ |:-------------------------------|
| playing |`(Boolean)`Pass true to resume playback, or false to pause it|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.setIsPlaying(true,(error)=>{console.log(error);});`

---

**-setShuffle:**

Set state for shuffle, on or off.

| Parameter |description|
| ------ |:-------------------------------|
|enable|`(Boolean)` send `true` to enable of `false` to disable |
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.stop((error)=>{console.log(error);});`

---

**-setRepeat:**

Set repeat state off, on or repeat-one

| Parameter |description|
| ------ |:-------------------------------|
|mode|`(Number)` send `0` for **off** , `1` for **on** or `2` for **repeat-one** |
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.stop((error)=>{console.log(error);});`

---

**[-skipNext:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/skipNext:)**

Go to the next track in the queue

| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.skipNext((error)=>{console.log(error);});`

---

**[-skipPrevious:(RCTResponseSenderBlock)block](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/skipPrevious:)**

Go to the previous track in the queue

| Parameter |description|
| ------ |:-------------------------------|
|Callback|`(Function)`a callback that will pass back an `NSError` object if an error occurred|

Example:

`SpotifyModule.skipPrevious((error)=>{console.log(error);});`

___


### *Events:*
> The native module can signal events to JavaScript without being invoked directly. JavaScript code can subscribe to these events by creating a new `NativeEventEmitter` instance around your module.

| Event |description|body|
| ------ |:------------------|:-------------|
|`didReceiveError`|Called on error|`error`|
|`audioStreamingDidLogin`|Called when the streaming controller logs in successfully|`error`|
|`audioStreamingDidLogout`|Called when the streaming controller logs out|`error`|
|`didEncounterTemporaryConnectionError`|Called when the streaming controller encounters a temporary connection error|`N/A`|
|`didReceiveMessage`|Called when the streaming controller received a message for the end user from the Spotify service|`message`|
|`audioStreamingDidDisconnect`|Called when network connectivity is lost|`N/A`|
|`audioStreamingDidReconnect`|Called when network connectivity is back after being lost|`N/A`|
|`didReceivePlaybackEvent`|Called for each received low-level event|`event`|
|`didChangePosition`|Called when playback has progressed|`position`|
|`didChangePlaybackStatus`|Called when playback status changes|`isPlaying`|
|`didSeekToPosition`|Called when playback is sought "unnaturally" to a new location|`position`|
|`didChangeVolume`|Called when playback volume changes|`volume`|
|`didChangeShuffleStatus`|Called when shuffle status changes|`enabled`|
|`didChangeRepeatStatus`|Called when repeat status changes|`repeateMode`|
|`didChangeMetadata`|Called when metadata for current, previous, or next track is changed|`metadata`|
|`didStartPlayingTrack`|Called when the streaming controller begins playing a new track|`trackUri`|
|`didStopPlayingTrack`|Called before the streaming controller begins playing another track|`trackUri`|
|`audioStreamingDidSkipToNextTrack`|Called when the audio streaming object requests playback skips to the next track|`N/A`|
|`audioStreamingDidSkipToPreviousTrack`|Called when the audio streaming object requests playback skips to the previous track|`N/A`|
|`audioStreamingDidBecomeActivePlaybackDevice`|Called when the audio streaming object becomes the active playback device on the user's account|`N/A`|
|`audioStreamingDidBecomeInactivePlaybackDevice`|Called when the audio streaming object becomes an inactive playback device on the user's account|`N/A`|
|`audioStreamingDidLosePermissionForPlayback`|Called when the streaming controller lost permission to play audio|`N/A`|
|`audioStreamingDidPopQueu`|Called when the streaming controller popped a new item from the `playqueue`|`N/A`|



## SPTSearch Class:
### *Methods:*

**[+performSearchWithQuery:queryType:offset:accessToken:market:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTSearch.html#//api/name/performSearchWithQuery:queryType:offset:accessToken:market:callback:)**

Go to the previous track in the queue *You need to have a session first*

| Parameter |description|
| ------ |:-------------------------------|
| searchQuery |`(String)`The query to pass to the search|
| searchQueryType |`(String)`The type of search to do ('track', 'artist', 'album' or 'playList')|
| offset |`(Number)`The index at which to start returning results|
| market |`(String)`Either a ISO 3166-1 country code to filter the results to, or “from_token” |
|Callback|`(Function)`callback to be called when the operation is complete. The block will pass an Array filled with json Objects on success, otherwise an error.|

Example:
```javascript
SpotifyModule.performSearchWithQuery('lacri','artist',0,'US',(err, res)=>{
      console.log('error', err);
      console.log('result', res);
    });
```

___


## Demo:
>Included in the repo.


![Alt Text](https://github.com/viestat/react-native-spotify/raw/master/spotifyModuleDemoEdit.gif)

___

