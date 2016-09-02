# React Native Spotify Module (IOS) 
___

###Notes

###Removed from API

####Properties:

*`isPlaying`
*`shuffle`
*`repeat`
*`currentPlaybackPosition`
*`currentTrackDuration`
*`currentTrackURI`
*`currentTrackIndex`

___

####Methods:

*`-seekToOffset:callback:` (changed to: `-seekTo:callback`)
*`-playURIs:withOptions:callback:`
*`-replaceURIs:withCurrentTrack:callback:`
*`-playURI:callback:`
*`-queueURI:callback:`

___

###Added to the API

####Properties:

*`metadata`
*`playbackState`

___

####Methods:

*`-seekTo:callback:`
*`-playSpotifyURI:startingWithIndex:startingWithPosition:callback:`
*`-queueSpotifyURI:callback:`


___


