//
//  SpotifyLoginViewController.m
//  spotifyModule
//
//  Created by Jack on 8/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "SpotifyLoginViewController.h"
#import "AppDelegate.h"
#import "SpotifyAuth.h"

@interface SpotifyLoginViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic) NSURL *login;

@end

@implementation SpotifyLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
  _webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                configuration:configuration];
  _webView.navigationDelegate = self;
  _webView.allowsBackForwardNavigationGestures = true;
  
  [self setTitle:@"Log In"];
  //This creates a Done Button on the top left corner of the view
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(hideTheThing)];
  
  // Load the login URL into the WKWebView
  [_webView loadRequest:[NSURLRequest requestWithURL:_login]];
  self.view = _webView;
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)hideTheThing {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithURL:(NSURL *)url
{
  _login = url;
  return self;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  SpotifyAuth *sharedManager = [SpotifyAuth sharedManager];
  NSURL *url = navigationAction.request.URL;
  //Set myScheme to your own Url Scheme
  NSString *myScheme = [[sharedManager myScheme] stringByReplacingOccurrencesOfString:@"://callback" withString:@""];
      if ([url.scheme isEqualToString:myScheme]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [sharedManager urlCallback:url];
          [self hideTheThing];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
      }
      decisionHandler(WKNavigationActionPolicyAllow);
    }


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
