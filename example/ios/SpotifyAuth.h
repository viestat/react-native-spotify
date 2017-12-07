//
//  SpotifyAuth.h
//  spotifyModule
//
//  Created by Jack on 8/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface SpotifyAuth : RCTEventEmitter <RCTBridgeModule, SPTAudioStreamingDelegate>
@property (nonatomic, strong) NSString *myScheme;
-(void)urlCallback: (NSURL *)url;
+ (id)sharedManager;
@end
