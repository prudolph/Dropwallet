//
//  TrackingModalWebViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TrackingModalWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,retain)NSString *trackingUrl;
@property(nonatomic,retain)IBOutlet UIWebView *trackingWebView;

-(IBAction)doneButtonPressed;
@end
