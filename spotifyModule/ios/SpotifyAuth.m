//
//  SpotifyAuth.m
//  spotifyModule
//
//  Created by Jack on 8/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "SpotifyLoginViewController.h"
#import "SpotifyAuth.h"
#import "SpotifyLoginViewController.h"
#import "AppDelegate.h"

@interface SpotifyAuth ()
@property (nonatomic, strong) SPTAuth *auth;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSArray *requestedScopes;
@end

@implementation SpotifyAuth

RCT_EXPORT_MODULE()

//Start Auth process
RCT_REMAP_METHOD(
                 initWithCredentials,
                 setClientID:(NSString *) clientID
                 setRedirectURL:(NSString *) redirectURL
                 setRequestedScopes:(NSArray *) requestedScopes
                 callback:(RCTResponseSenderBlock)block
                 )
{
  SpotifyAuth *sharedManager = [SpotifyAuth sharedManager];
  
  self.auth = [SPTAuth defaultInstance];
  self.player = [SPTAudioStreamingController sharedInstance];
  self.auth.clientID = clientID;
  // The redirect URL as you entered it at the developer site
  self.auth.redirectURL = [NSURL URLWithString:redirectURL];
  // Setting the `sessionUserDefaultsKey` enables SPTAuth to automatically store the session object for future use.
  self.auth.sessionUserDefaultsKey = @"current session";
  // Set the scopes you need the user to authorize. `SPTAuthStreamingScope` is required for playing audio.
  self.auth.requestedScopes = [self parseScopes:requestedScopes];
  // Become the streaming controller delegate
  self.player.delegate = self;
  
  [sharedManager setMyScheme:redirectURL];
  
  // Start up the streaming controller.
  NSError *audioStreamingInitError;
  
  BOOL success = [self.player startWithClientId:self.auth.clientID error:&audioStreamingInitError];
  
  if(success) {
    block(@[@(success), [NSNull null]]);
  } else {
    block(@[@(success),audioStreamingInitError.description]);
  }
  
}



/////////////////////////////////
////  SPTAudioStreamingController
/////////////////////////////////

///-----------------------------
/// Properties
///-----------------------------

//Returns true when SPTAudioStreamingController is initialized, otherwise false
RCT_EXPORT_METHOD(initialized:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn initialized])]);
}

//Returns true if the receiver is logged into the Spotify service, otherwise false
RCT_EXPORT_METHOD(loggedIn:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn loggedIn])]);
}

//Returns the volume, as a value between 0.0 and 1.0.
RCT_EXPORT_METHOD(volume:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn volume])]);
}

//Returns the Metadata for the currently playing context
RCT_EXPORT_METHOD(metadata:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[[sharedIn metadata]]);
}

//Returns the players current state
RCT_EXPORT_METHOD(playbackState:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[[sharedIn playbackState]]);
}

//Returns the current streaming bitrate the receiver is using
RCT_EXPORT_METHOD(targetBitrate:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn targetBitrate])]);
}

///-----------------------------
/// Methods
///-----------------------------

//Logout from Spotify
RCT_EXPORT_METHOD(logout)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn logout];
}

//Set playback volume to the given level. Volume is a value between `0.0` and `1.0`.
RCT_EXPORT_METHOD(setVolume:(CGFloat)volume callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn setVolume:volume callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Set the target streaming bitrate. 0 for low, 1 for normal and 2 for high
RCT_EXPORT_METHOD(setTargetBitrate:(NSInteger)bitrate callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn setTargetBitrate:bitrate callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Seek playback to a given location in the current track (in secconds).
RCT_EXPORT_METHOD(seekTo:(CGFloat)offset callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn seekTo:offset callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Set the "playing" status of the receiver. Pass true to resume playback, or false to pause it.
RCT_EXPORT_METHOD(setIsPlaying:(BOOL)playing callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn setIsPlaying: playing callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Play a Spotify URI.
RCT_EXPORT_METHOD(playSpotifyURI:(NSString *) spotifyUri startingWithIndex:(NSInteger) index startingWithPosition:(CGFloat) position callback:(RCTResponseSenderBlock)block)
{
  //  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [self.player playSpotifyURI:spotifyUri startingWithIndex:index startingWithPosition:position callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Queue a Spotify URI.
RCT_EXPORT_METHOD(queueSpotifyURI:(NSString *)spotifyUri callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn queueSpotifyURI:spotifyUri callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Go to the next track in the queue
RCT_EXPORT_METHOD(skipNext:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn skipNext:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Go to the previous track in the queue
RCT_EXPORT_METHOD(skipPrevious:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn skipPrevious:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Set state for shuffle, on or off
RCT_EXPORT_METHOD(setShuffle:(BOOL)enable callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn setShuffle:enable callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Set repeat state, on, off or repeat-one
RCT_EXPORT_METHOD(setRepeat:(NSInteger)mode callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn setRepeat:mode callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

///-----------------------------
/// Events
///-----------------------------

- (NSArray<NSString *> *)supportedEvents
{
  return @[
           @"didReceiveError",
           @"audioStreamingDidLogin",
           @"audioStreamingDidLogout",
           @"didEncounterTemporaryConnectionError",
           @"didReceiveMessage",
           @"audioStreamingDidDisconnect",
           @"audioStreamingDidReconnect",
           @"didReceivePlaybackEvent",
           @"didChangePosition",
           @"didChangePlaybackStatus",
           @"didSeekToPosition",
           @"didChangeVolume",
           @"didChangeShuffleStatus",
           @"didChangeRepeatStatus",
           @"didChangeMetadata",
           @"didStartPlayingTrack",
           @"didStopPlayingTrack",
           @"audioStreamingDidSkipToNextTrack",
           @"audioStreamingDidSkipToPreviousTrack",
           @"audioStreamingDidBecomeActivePlaybackDevice",
           @"audioStreamingDidBecomeInactivePlaybackDevice",
           @"audioStreamingDidLosePermissionForPlayback",
           @"audioStreamingDidPopQueue"
           ];
}

/** Called on error
 @param audioStreaming The object that sent the message.
 @param error An NSError. Domain is SPTAudioStreamingErrorDomain and code is one of SpErrorCode
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError *)error
{
  [self sendEventWithName:@"didReceiveError" body:@{@"error": @[error]}];
}

/** Called when the streaming controller logs in successfully.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidLogin" body:@{@"error": @[[NSNull null]]}];
}

/** Called when the streaming controller logs out.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidLogout" body:@{@"error": @[[NSNull null]]}];
}

/** Called when the streaming controller encounters a temporary connection error.
 
 You should not throw an error to the user at this point. The library will attempt to reconnect without further action.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidEncounterTemporaryConnectionError:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"didEncounterTemporaryConnectionError" body:@{}];
}

/** Called when the streaming controller recieved a message for the end user from the Spotify service.
 
 This string should be presented to the user in a reasonable manner.
 
 @param audioStreaming The object that sent the message.
 @param message The message to display to the user.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message
{
  [self sendEventWithName:@"didReceiveMessage" body:@{@"message": message}];
}

/** Called when network connectivity is lost.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidDisconnect:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidDisconnect" body:@{}];
}

/** Called when network connectivitiy is back after being lost.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidReconnect:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidReconnect" body:@{}];
}


/** Called for each received low-level event
 @param audioStreaming The object that sent the message.
 @param event The event code
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceivePlaybackEvent:(SpPlaybackEvent)event
{
  [self sendEventWithName:@"didReceivePlaybackEvent" body:@{@"event": @(event)}];
}

/** Called when playback has progressed
 @param audioStreaming The object that sent the message.
 @param position The new playback location in sec.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePosition:(NSTimeInterval)position
{
  [self sendEventWithName:@"didChangePosition" body:@{@"position": [NSNumber numberWithDouble:position]}];
}

/** Called when playback status changes.
 @param audioStreaming The object that sent the message.
 @param isPlaying Set to `YES` if the object is playing audio, `NO` if it is paused.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying
{
  [self sendEventWithName:@"didChangePlaybackStatus" body:@{@"isPlaying": @(isPlaying)}];
}

/** Called when playback is seeked "unaturally" to a new location.
 @param audioStreaming The object that sent the message.
 @param position The new playback location in sec.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didSeekToPosition:(NSTimeInterval)position
{
  [self sendEventWithName:@"didSeekToPosition" body:@{@"position": [NSNumber numberWithDouble:position]}];
}

/** Called when playback volume changes.
 @param audioStreaming The object that sent the message.
 @param volume The new volume.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeVolume:(SPTVolume)volume
{
  [self sendEventWithName:@"didChangeVolume" body:@{@"volume": @(volume)}];
}

/** Called when shuffle status changes.
 @param audioStreaming The object that sent the message.
 @param enabled Set to `YES` if the object requests shuffled playback, otherwise `NO`.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeShuffleStatus:(BOOL)enabled
{
  [self sendEventWithName:@"didChangeShuffleStatus" body:@{@"enabled": @(enabled)}];
}


/** Called when repeat status changes.
 @param audioStreaming The object that sent the message.
 @param repeateMode Set to `SPTRepeatOff`, `SPTRepeatContext` or `SPTRepeatOne`.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeRepeatStatus:(SPTRepeatMode)repeateMode
{
  [self sendEventWithName:@"didChangeRepeatStatus" body:@{@"repeateMode": @(repeateMode)}];
}


/** Called when metadata for current, previous, or next track is changed.
 *
 * This event occurs when playback starts or changes to a different context,
 * when a track switch occurs, etc. This is an informational event that does
 * not require action, but should be used to keep the UI display updated with
 * the latest metadata information.
 *
 @param audioStreaming The object that sent the message.
 @param metadata for previous, current, and next tracks
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeMetadata:(SPTPlaybackMetadata *)metadata
{
  [self sendEventWithName:@"didChangeMetadata" body:@{@"metadata": metadata}];
}

/** Called when the streaming controller begins playing a new track.
 
 @param audioStreaming The object that sent the message.
 @param trackUri The Spotify URI of the track that started to play.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri
{
  [self sendEventWithName:@"didStartPlayingTrack" body:@{@"trackUri": trackUri}];
}

/** Called before the streaming controller begins playing another track.
 
 @param audioStreaming The object that sent the message.
 @param trackUri The Spotify URI of the track that stopped.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStopPlayingTrack:(NSString *)trackUri
{
  [self sendEventWithName:@"didStopPlayingTrack" body:@{@"trackUri": trackUri}];
}

/** Called when the audio streaming object requests playback skips to the next track.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidSkipToNextTrack" body:@{}];
}

/** Called when the audio streaming object requests playback skips to the previous track.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidSkipToPreviousTrack:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidSkipToPreviousTrack" body:@{}];
}

/** Called when the audio streaming object becomes the active playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidBecomeActivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidBecomeActivePlaybackDevice" body:@{}];
}

/** Called when the audio streaming object becomes an inactive playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidBecomeInactivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidBecomeInactivePlaybackDevice" body:@{}];
}

/** Called when the streaming controller lost permission to play audio.
 
 This typically happens when the user plays audio from their account on another device.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLosePermissionForPlayback:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidLosePermissionForPlayback" body:@{}];
}

/** Called when the streaming controller popped a new item from the playqueue.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidPopQueue:(SPTAudioStreamingController *)audioStreaming
{
  [self sendEventWithName:@"audioStreamingDidPopQueue" body:@{}];
}

/////////////////////////////////
////  END SPTAudioStreamingController
/////////////////////////////////


/////////////////////////////////
////  Search
/////////////////////////////////

///-----------------------------
/// Properties
///-----------------------------

///-----------------------------
/// Methods
///-----------------------------

//Performs a search with a given query, offset and market filtering, returns an Array filled with json Objects
/*
 */
//RCT_EXPORT_METHOD(performSearchWithQuery:(NSString *)searchQuery
//                  queryType:(NSString *)searchQueryType
//                  offset:(NSInteger)offset
//                  market:(NSString *)market
//                  callback:(RCTResponseSenderBlock)block)
//{
//  SPTSearchQueryType parm;
//  //set the SPTSearchQueryType depending on searchQueryType
//  if ([searchQueryType  isEqual: @"track"]){
//    parm = SPTQueryTypeTrack;
//  } else if ([searchQueryType  isEqual: @"artist"]){
//    parm = SPTQueryTypeArtist;
//  } else if ([searchQueryType  isEqual: @"album"]){
//    parm = SPTQueryTypeAlbum;
//  } else if ([searchQueryType  isEqual: @"playList"]){
//    parm = SPTQueryTypePlaylist;
//  }
//
//  [SPTSearch performSearchWithQuery:searchQuery queryType:parm offset:offset accessToken:[[[SpotifyAuth sharedManager] session] accessToken] market:market callback:^(NSError *error, id object) {
//
//    NSMutableDictionary *resObj = [NSMutableDictionary dictionary];
//    NSMutableArray *resArr = [NSMutableArray array];
//    for (int i; i < [[object items] count]; i++){
//      SPTPartialArtist *temp = (SPTPartialArtist *)[object items][i];
//      resObj[[temp name]] = [temp decodedJSONObject];
//      [resArr addObject:[temp decodedJSONObject]];
//    }
//    NSLog(@"ret %@ ret", [object nextPageURL]);
//    block(@[[NSNull null],resArr]);
//    return;
//  }];
//
//}

/////////////////////////////////
////  END Search
/////////////////////////////////

RCT_REMAP_METHOD(
                 startAuthenticationFlow,
                 callback:(RCTResponseSenderBlock)block
                 )
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  // Check if we could use the access token we already have
  if ([self.auth.session isValid]) {
    // Use it to log in
    [self.player loginWithAccessToken:self.auth.session.accessToken];
  } else {
    // Get the URL to the Spotify authorization portal
    NSURL *authURL = [self.auth spotifyWebAuthenticationURL];
    
    SpotifyLoginViewController *webView1 =[[SpotifyLoginViewController alloc] initWithURL:authURL];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController: webView1];
    
    [delegate.window.rootViewController presentViewController: controller animated:YES completion:nil];
    
    //Observer for successful login
    [center addObserverForName:@"loginRes" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
       //if there is an error key in the userInfo dictionary send the error, otherwise null
       if(notification.userInfo[@"error"] != nil){
         block(@[notification.userInfo[@"error"]]);
       } else {
         block(@[[NSNull null]]);
       }
       
     }];
  }
}

//- (BOOL)startAuth:(NSString *) clientID setRedirectURL:(NSString *) redirectURL setRequestedScopes:(NSArray *) requestedScopes {
//  NSMutableArray *scopes = [NSMutableArray array];
//  //Turn scope arry of strings into an array of SPTAuth...Scope objects
//  for (int i = 0; i < [requestedScopes count]; i++) {
//    if([requestedScopes[i]  isEqual: @"playlist-read-private"]){
//      [scopes addObject: SPTAuthPlaylistReadPrivateScope];
//    } else if([requestedScopes[i]  isEqual: @"playlist-modify-private"]){
//      [scopes addObject: SPTAuthPlaylistModifyPrivateScope];
//    } else if([requestedScopes[i]  isEqual: @"playlist-modify-public"]){
//      [scopes addObject: SPTAuthPlaylistModifyPublicScope];
//    } else if([requestedScopes[i]  isEqual: @"user-follow-modify"]){
//      [scopes addObject: SPTAuthUserFollowModifyScope];
//    } else if([requestedScopes[i]  isEqual: @"user-follow-read"]){
//      [scopes addObject: SPTAuthUserFollowReadScope];
//    } else if([requestedScopes[i]  isEqual: @"user-library-read"]){
//      [scopes addObject: SPTAuthUserLibraryReadScope];
//    } else if([requestedScopes[i]  isEqual: @"user-library-modify"]){
//      [scopes addObject: SPTAuthUserLibraryModifyScope];
//    } else if([requestedScopes[i]  isEqual: @"user-read-private"]){
//      [scopes addObject: SPTAuthUserReadPrivateScope];
//    } else if([requestedScopes[i]  isEqual: @"user-read-birthdate"]){
//      [scopes addObject: SPTAuthUserReadBirthDateScope];
//    } else if([requestedScopes[i]  isEqual: @"user-read-email"]){
//      [scopes addObject: SPTAuthUserReadEmailScope];
//    } else if([requestedScopes[i]  isEqual: @"streaming"]){
//      [scopes addObject: SPTAuthStreamingScope];
//    }
//  }
//  /*
//   FOUNDATION_EXPORT NSString * const SPTAuthStreamingScope;
//   */
//  [[SPTAuth defaultInstance] setClientID:clientID];
//  [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:redirectURL]];
//  [[SPTAuth defaultInstance] setRequestedScopes:scopes];
//
//  // Construct a login URL
//  NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];
//
//  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//  // init the webView with the loginURL
//  SpotifyLoginViewController *webView1 =[[SpotifyLoginViewController alloc] initWithURL:loginURL];
//  UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController: webView1];
//
//  //Present the webView over the rootView
//  [delegate.window.rootViewController presentViewController: controller animated:YES completion:nil];
//
//
//
//  return YES;
//}

-(void)urlCallback: (NSURL *)url {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  NSMutableDictionary *loginRes =  [NSMutableDictionary dictionary];
  if ([[SPTAuth defaultInstance] canHandleURL:url]) {
    [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
      
      if (error != nil) {
        NSLog(@"*** Auth error: %@", error);
        loginRes[@"error"] = @"error while attempting to login!";
        
      } else {
        if (session) {
          // login to the player
          [self.player loginWithAccessToken:self.auth.session.accessToken];
        }
        
        //      // Create a new player if needed
        //      if (self.player == nil) {
        //        //Set the session property to the seesion we got from the login Url
        //        SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
        //        [sharedIn startWithClientId:[SPTAuth defaultInstance].clientID error:nil];
        //        self.player = sharedIn;
        //        //keep this one
        //        [[SpotifyAuth sharedManager] setSession:session];
        //
        //      }
        //
        //        [self.player loginWithAccessToken:self.auth.session.accessToken];
        
      }
      
    }];
  } else {
    loginRes[@"error"] = @"error while attempting to login!";
  }
  [center postNotificationName:@"loginRes" object:nil userInfo:loginRes];
  [center removeObserver:self name:@"loginRes" object:nil];
  
}

//Check if session is valid and renew it if not
-(void)checkSession{
  //  SpotifyAuth *sharedManager = [SpotifyAuth sharedManager];
  if (![self.auth.session isValid]){
    [[SPTAuth defaultInstance] renewSession:self.auth.session callback:^(NSError *error, SPTSession *session) {
      if(error != nil){
        NSLog(@"Error: %@", error);
        //launch the login again
        //        [sharedManager startAuth:sharedManager.clientID setRedirectURL:sharedManager.myScheme setRequestedScopes:sharedManager.requestedScopes];
      } else {
        //        [[SpotifyAuth sharedManager]  setSession:session];
        [self.player loginWithAccessToken:self.auth.session.accessToken];
      }
    }];
  }
  
}

-(void)setMyScheme:(NSString *)myScheme{
  _myScheme = myScheme;
}

-(void)setClientID:(NSString *)clientID{
  _clientID = clientID;
}

-(void)setRequestedScopes:(NSArray *)requestedScopes{
  _requestedScopes = requestedScopes;
}

+ (id)sharedManager {
  static SpotifyAuth *sharedMyManager = nil;
  @synchronized(self) {
    if (sharedMyManager == nil)
      sharedMyManager = [[self alloc] init];
  }
  return sharedMyManager;
}

-(NSArray *) parseScopes: (NSArray *) requestedScopes {
  NSMutableArray *scopes = [NSMutableArray array];
  
  for (int i = 0; i < [requestedScopes count]; i++) {
    if([requestedScopes[i]  isEqual: @"playlist-read-private"]){
      [scopes addObject: SPTAuthPlaylistReadPrivateScope];
    } else if([requestedScopes[i]  isEqual: @"playlist-modify-private"]){
      [scopes addObject: SPTAuthPlaylistModifyPrivateScope];
    } else if([requestedScopes[i]  isEqual: @"playlist-modify-public"]){
      [scopes addObject: SPTAuthPlaylistModifyPublicScope];
    } else if([requestedScopes[i]  isEqual: @"user-follow-modify"]){
      [scopes addObject: SPTAuthUserFollowModifyScope];
    } else if([requestedScopes[i]  isEqual: @"user-follow-read"]){
      [scopes addObject: SPTAuthUserFollowReadScope];
    } else if([requestedScopes[i]  isEqual: @"user-library-read"]){
      [scopes addObject: SPTAuthUserLibraryReadScope];
    } else if([requestedScopes[i]  isEqual: @"user-library-modify"]){
      [scopes addObject: SPTAuthUserLibraryModifyScope];
    } else if([requestedScopes[i]  isEqual: @"user-read-private"]){
      [scopes addObject: SPTAuthUserReadPrivateScope];
    } else if([requestedScopes[i]  isEqual: @"user-read-birthdate"]){
      [scopes addObject: SPTAuthUserReadBirthDateScope];
    } else if([requestedScopes[i]  isEqual: @"user-read-email"]){
      [scopes addObject: SPTAuthUserReadEmailScope];
    } else if([requestedScopes[i]  isEqual: @"streaming"]){
      [scopes addObject: SPTAuthStreamingScope];
    }
  }
  
  return scopes;
}

@end
