//
//  TrackingModalViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TrackingModalViewController : UIViewController<UIWebViewDelegate>
{
    NSString *urlString;
        IBOutlet UINavigationBar *trackingToolBar;
}
@property(nonatomic,retain)NSString *urlString;
@property(nonatomic,retain)IBOutlet UINavigationBar *trackingToolBar;
@property(nonatomic,retain)UIActivityIndicatorView *loadIndicator;
@property (nonatomic,retain)    AppDelegate *appDel;
-(IBAction)doneButtonSelected:(id)sender;
@end
