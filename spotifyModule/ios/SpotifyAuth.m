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
@end

@implementation SpotifyAuth

RCT_EXPORT_MODULE()

//Start Auth process
RCT_EXPORT_METHOD(setClientID:(NSString *) clientID
                  setRedirectURL:(NSString *) redirectURL
                  setRequestedScopes:(NSArray *) requestedScopes)
{
  [self startAuth:clientID setRedirectURL:redirectURL setRequestedScopes:requestedScopes];
}

//Logout from Spotify
RCT_EXPORT_METHOD(logout)
{
  [self.player logout];
}

//Returns true when SPTAudioStreamingController is initialized, otherwise false
RCT_EXPORT_METHOD(initialized:(RCTResponseSenderBlock)block)
{
  block(@[[NSNull null], @([self.player initialized])]);
}

//Returns true if the receiver is logged into the Spotify service, otherwise false
RCT_EXPORT_METHOD(loggedIn:(RCTResponseSenderBlock)block)
{
  block(@[[NSNull null], @([self.player loggedIn])]);
}



- (BOOL)startAuth:(NSString *) clientID setRedirectURL:(NSString *) redirectURL setRequestedScopes:(NSArray *) requestedScopes {
  [[SPTAuth defaultInstance] setClientID:clientID];
  [[SPTAuth defaultInstance] setRedirectURL:[NSURL URLWithString:redirectURL]];
  [[SPTAuth defaultInstance] setRequestedScopes:@[SPTAuthStreamingScope]];
  
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

-(BOOL)urlCallback: (NSURL *)url {
  if ([[SPTAuth defaultInstance] canHandleURL:url]) {
    [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
      
      if (error != nil) {
        NSLog(@"*** Auth error: %@", error);
        return;
      }
      
      // Create a new player if needed
      if (self.player == nil) {
        //Set the session property to the seesion we got from the login Url
        _session = session;
        SPTAudioStreamingController *sharedIn = [SPTAudioStreamingController sharedInstance];
        [sharedIn startWithClientId:[SPTAuth defaultInstance].clientID error:nil];
        self.player = sharedIn;

      }
      
      [self.player loginWithAccessToken:_session.accessToken];
      
      //this is used to play a song
//      NSURL *trackURI = [NSURL URLWithString:@"spotify:track:58s6EuEYJdlb0kO7awm3Vp"];
//      //this method plays the tracks in an Array
//      [self.player playURIs:@[trackURI] fromIndex:0 callback:^(NSError *error) {
//        if (error != nil) {
//          NSLog(@"*** Starting playback got error: %@", error);
//          return;
//        }
//      }];
  
      
      
      
    }];
    return YES;
  }
  
  return NO;
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
