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

RCT_EXPORT_METHOD(setClientID:(NSString *) clientID
                  setRedirectURL:(NSString *) redirectURL
                  setRequestedScopes:(NSArray *) requestedScopes)
{
  [self startAuth:clientID setRedirectURL:redirectURL setRequestedScopes:requestedScopes];
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

@end
