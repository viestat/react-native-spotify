//
//  SpotifyAuth.m
//  spotifyModule
//
//  Created by Jack on 8/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Spotify/Spotify.h>
#import "SpotifyAuth.h"
#import "SpotifyLoginViewController.h"
#import "AppDelegate.h"

@interface SpotifyAuth ()
@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSArray *requestedScopes;
@end

@implementation SpotifyAuth

RCT_EXPORT_MODULE()

//Start Auth process
RCT_EXPORT_METHOD(setClientID:(NSString *) clientID
                  setRedirectURL:(NSString *) redirectURL
                  setRequestedScopes:(NSArray *) requestedScopes
                  callback:(RCTResponseSenderBlock)block)
{
  SpotifyAuth *sharedManager = [SpotifyAuth sharedManager];
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  //set the sharedManager properties
  [sharedManager setClientID:clientID];
  [sharedManager setRequestedScopes:requestedScopes];
  [sharedManager setMyScheme:redirectURL];

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

  [self startAuth:clientID setRedirectURL:redirectURL setRequestedScopes:requestedScopes];
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

//Returns true if the receiver is playing audio, otherwise false
RCT_EXPORT_METHOD(isPlaying:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn isPlaying])]);
}

//Returns the volume, as a value between 0.0 and 1.0.
RCT_EXPORT_METHOD(volume:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn volume])]);
}

//Returns true if the receiver expects shuffled playback, otherwise false
RCT_EXPORT_METHOD(shuffle:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn shuffle])]);
}

//Returns true if the receiver expects repeated playback, otherwise false
RCT_EXPORT_METHOD(repeat:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn repeat])]);
}

//Returns the current approximate playback position of the current track
RCT_EXPORT_METHOD(currentPlaybackPosition:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn currentPlaybackPosition])]);
}

//Returns the length of the current track
RCT_EXPORT_METHOD(currentTrackDuration:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn currentTrackDuration])]);
}

//Returns the current track URI, playing or not
RCT_EXPORT_METHOD(currentTrackURI:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[[[sharedIn currentTrackURI] absoluteString]]);
}

//Returns the currenly playing track index
RCT_EXPORT_METHOD(currentTrackIndex:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  block(@[@([sharedIn currentTrackIndex])]);
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
RCT_EXPORT_METHOD(seekToOffset:(CGFloat)offset callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn seekToOffset:offset callback:^(NSError *error) {
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

//Play a list of Spotify URIs.(at most 100 tracks).`SPTPlayOptions` containing extra information about the play request such as which track to play and from which starting position within the track.
RCT_EXPORT_METHOD(playURIs:(NSArray *)uris withOptions:(NSDictionary *)options callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  NSMutableArray *urisArr = [NSMutableArray arrayWithArray:uris];
  SPTPlayOptions *playOptions = [[SPTPlayOptions alloc] init];
  //set the properties of the SPTPlayOptions 'options'
  if(options[@"trackIndex"] != nil){
    [playOptions setTrackIndex:[[options objectForKey:@"trackIndex"]intValue]];
  }
  if(options[@"startTime"] != nil){
    [playOptions setStartTime:[options[@"startTime"] floatValue]];
  }
  
  //Turn all the strings in urisArr to NSURL
  for (int i = 0; i < [urisArr count]; i++) {
    urisArr[i] = [NSURL URLWithString:urisArr[i]];
  }
  [sharedIn playURIs:urisArr withOptions:playOptions callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

// Replace the current list of tracks without stopping playback.
RCT_EXPORT_METHOD(replaceURIs:(NSArray *)uris withCurrentTrack:(int)index callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  NSMutableArray *urisArr = [NSMutableArray arrayWithArray:uris];
  //Turn all the strings in urisArr to NSURL
  for (int i = 0; i < [urisArr count]; i++) {
    urisArr[i] = [NSURL URLWithString:urisArr[i]];
  }
  
  [sharedIn replaceURIs:urisArr withCurrentTrack:index callback:^(NSError *error) {
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
RCT_EXPORT_METHOD(playURI:(NSString *)uri callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn playURI:[NSURL URLWithString:uri] callback:^(NSError *error) {
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
RCT_EXPORT_METHOD(queueURI:(NSString *)uri callback:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn queueURI:[NSURL URLWithString:uri] callback:^(NSError *error) {
    if(error == nil){
      block(@[[NSNull null]]);
    }else{
      block(@[error]);
      [self checkSession];
    }
    return;
  }];
}

//Stop playback and clear the queue and list of tracks.
RCT_EXPORT_METHOD(stop:(RCTResponseSenderBlock)block)
{
  SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
  [sharedIn stop:^(NSError *error) {
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
RCT_EXPORT_METHOD(performSearchWithQuery:(NSString *)searchQuery
                  queryType:(NSString *)searchQueryType
                  offset:(NSInteger)offset
                  market:(NSString *)market
                  callback:(RCTResponseSenderBlock)block)
{
  SPTSearchQueryType parm;
  //set the SPTSearchQueryType depending on searchQueryType
  if ([searchQueryType  isEqual: @"track"]){
    parm = SPTQueryTypeTrack;
  } else if ([searchQueryType  isEqual: @"artist"]){
    parm = SPTQueryTypeArtist;
  } else if ([searchQueryType  isEqual: @"album"]){
    parm = SPTQueryTypeAlbum;
  } else if ([searchQueryType  isEqual: @"playList"]){
    parm = SPTQueryTypePlaylist;
  }
  
  [SPTSearch performSearchWithQuery:searchQuery queryType:parm offset:offset accessToken:[[[SpotifyAuth sharedManager] session] accessToken] market:market callback:^(NSError *error, id object) {
    
    NSMutableDictionary *resObj = [NSMutableDictionary dictionary];
    NSMutableArray *resArr = [NSMutableArray array];
    for (int i; i < [[object items] count]; i++){
      SPTPartialArtist *temp = (SPTPartialArtist *)[object items][i];
      resObj[[temp name]] = [temp decodedJSONObject];
      [resArr addObject:[temp decodedJSONObject]];
    }
    NSLog(@"ret %@ ret", [object nextPageURL]);
    block(@[[NSNull null],resArr]);
    return;
  }];
  
}

/////////////////////////////////
////  END Search
/////////////////////////////////


- (BOOL)startAuth:(NSString *) clientID setRedirectURL:(NSString *) redirectURL setRequestedScopes:(NSArray *) requestedScopes {
  NSMutableArray *scopes = [NSMutableArray array];
  //Turn scope arry of strings into an array of SPTAuth...Scope objects
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
  /*
   FOUNDATION_EXPORT NSString * const SPTAuthStreamingScope;
   */
  [[SPTAuth defaultInstance] setClientID:clientID];
  [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:redirectURL]];
  [[SPTAuth defaultInstance] setRequestedScopes:scopes];
  
  // Construct a login URL 
  NSURL *loginURL = [[SPTAuth defaultInstance] loginURL];

  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  // init the webView with the loginURL
  SpotifyLoginViewController *webView1 =[[SpotifyLoginViewController alloc] initWithURL:loginURL];
  UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController: webView1];
  
  //Present the webView over the rootView
  [delegate.window.rootViewController presentViewController: controller animated:YES completion:nil];
  

  
  return YES;
}

-(void)urlCallback: (NSURL *)url {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  NSMutableDictionary *loginRes =  [NSMutableDictionary dictionary];
  if ([[SPTAuth defaultInstance] canHandleURL:url]) {
    [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
      
      if (error != nil) {
        NSLog(@"*** Auth error: %@", error);
        loginRes[@"error"] = @"error while attempting to login!";
        
      } else {
      
      // Create a new player if needed
      if (self.player == nil) {
        //Set the session property to the seesion we got from the login Url
        _session = session;
        [self setSession: session];
        SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
        [sharedIn startWithClientId:[SPTAuth defaultInstance].clientID error:nil];
        self.player = sharedIn;
        //keep this one
        [[SpotifyAuth sharedManager] setSession:session];

      }
      
        [self.player loginWithAccessToken:_session.accessToken];
        
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
  SpotifyAuth *sharedManager = [SpotifyAuth sharedManager];
  if (![[sharedManager session] isValid]){
    [[SPTAuth defaultInstance] renewSession:[sharedManager session] callback:^(NSError *error, SPTSession *session) {
      if(error != nil){
        NSLog(@"Error: %@", error);
        //launch the login again
        [sharedManager startAuth:sharedManager.clientID setRedirectURL:sharedManager.myScheme setRequestedScopes:sharedManager.requestedScopes];
      } else {
        [sharedManager setSession:session];
        [[sharedManager player] loginWithAccessToken:session.accessToken];
      }
    }];
  }
  
}

-(void)setSession:(SPTSession *)session{
  _session = session;
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

@end
