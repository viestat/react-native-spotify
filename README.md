# React Native Spotify Module (IOS) 


##Intro
This is a native module that exposes the Spotify SDK (IOS) to JavaScript.

___


##Exposed API:


###SPTAudioStreamingController Class:
### *Properties:*
**initialized**

Returns true when SPTAudioStreamingController is initialized, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.initialized((res)=>{console.log(res);});`

**[loggedIn](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/loggedIn)**

Returns true if the receiver is logged into the Spotify service, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.loggedIn((res)=>{console.log(res);});`

**[isPlaying](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/isPlaying)**

Returns true if the receiver is playing audio, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.isPlaying((res)=>{console.log(res);});`

**[volume](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/volume)**

Returns the volume


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.volume((res)=>{console.log(res);});`

**[shuffle](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/shuffle)**

Returns true if the receiver expects shuffled playback, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.shuffle((res)=>{console.log(res);});`

**[repeat](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/repeat)**

Returns true if the receiver expects repeated playback, otherwise false


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.repeat((res)=>{console.log(res);});`

**[currentPlaybackPosition](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/currentPlaybackPosition)**

Returns the current approximate playback position of the current track


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.currentPlaybackPosition((res)=>{console.log(res);});`

**[currentTrackDuration](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/currentTrackDuration)**

Returns the length of the current track


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.currentTrackDuration((res)=>{console.log(res);});`

**[currentTrackURI](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/currentTrackURI)**

Returns the current track URI, playing or not


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.currentTrackURI((res)=>{console.log(res);});`

**[currentTrackIndex](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/currentTrackIndex)**

Returns the currenly playing track index


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.currentTrackIndex((res)=>{console.log(res);});`

**[targetBitrate](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/targetBitrate)**

Returns the current streaming bitrate the receiver is using


| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback to handle the response|

Example:

`SpotifyModule.targetBitrate((res)=>{console.log(res);});`

### *Methods:*

**[-logout:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/logout:)**

Logout from Spotify

| Parameter |description|
| ------ |:-------------------------------|
|N/A|N/A|

Example:

`SpotifyModule.logout();`

**[-setVolume:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setVolume:callback:)**

Set playback volume to the given level. Volume is a value between `0.0` and `1.0`.

| Parameter |description|
| ------ |:-------------------------------|
|volume  |The volume to change to, a number between `0.0` and `1.0`|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.setVolume(0.8,(error)=>{console.log(error);});`

**[-setTargetBitrate:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setTargetBitrate:callback:)**

Set the target streaming bitrate. `0` for low, `1` for normal and `2` for high

| Parameter |description|
| ------ |:-------------------------------|
|bitrate|The bitrate to target            |
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.setTargetBitrate(2,(error)=>{console.log(error);});`

**[-seekToOffset:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/seekToOffset:callback:)**

Seek playback to a given location in the current track (in secconds).

| Parameter |description|
| ------ |:-------------------------------|
| offset |The time to seek to|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.seekToOffset(110,(error)=>{console.log(error);});`

**[-playURIs:withOptions:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/playURIs:withOptions:callback:)**

Play a list of Spotify URIs.(at most 100 tracks).`SPTPlayOptions` containing extra information about the play request such as which track to play and from which starting position within the track.

| Parameter |description|
| ------ |:-------------------------------|
| uris |The array of URI’s to play (at most 100 tracks)|
| options |Object with trackIndex and/or startTime (can be null)|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.playURIs(["spotify:track:6HxIUB3fLRS8W3LfYPE8tP",...], {trackIndex :0, startTime:12.0},(error)=>{console.log(error)});`

**[-replaceURIs:withCurrentTrack:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/replaceURIs:withCurrentTrack:callback:)**
 
 Replace the current list of tracks without stopping playback.

| Parameter |description|
| ------ |:-------------------------------|
| uris |The array of URI’s to play|
| index |The current track in the list|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.replaceURIs(["spotify:track:6HxIUB3fLRS8W3LfYPE8tP",...], 0, (error)=>{console.log(error)});`

**[-playURI:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/playURI:callback:)**

Play a Spotify URI.

| Parameter |description|
| ------ |:-------------------------------|
| uri |The URI to play|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.playURI("spotify:track:6HxIUB3fLRS8W3LfYPE8tP",(error)=>{console.log(error);});`

**[-queueURI:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/queueURI:callback:)**

Queue a Spotify URI.

| Parameter |description|
| ------ |:-------------------------------|
| uri |The URI to queue|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.queueURI("spotify:track:6HxIUB3fLRS8W3LfYPE8tP",(error)=>{console.log(error);});`

**[-setIsPlaying:callback:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/setIsPlaying:callback:)**

Set the "playing" status of the receiver.

| Parameter |description|
| ------ |:-------------------------------|
| playing |Pass true to resume playback, or false to pause it|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.setIsPlaying(true,(error)=>{console.log(error);});`

**[-stop:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/stop:)**

Stop playback and clear the queue and list of tracks.

| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.stop((error)=>{console.log(error);});`

**[-skipNext:](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/skipNext:)**

Go to the next track in the queue

| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.skipNext((error)=>{console.log(error);});`

**[-skipPrevious:(RCTResponseSenderBlock)block](https://developer.spotify.com/ios-sdk-docs/Documents/Classes/SPTAudioStreamingController.html#//api/name/skipPrevious:)**

Go to the previous track in the queue

| Parameter |description|
| ------ |:-------------------------------|
|Callback|a callback that will pass back an `NSError` object if an error ocurred|

Example:

`SpotifyModule.skipPrevious((error)=>{console.log(error);});`

