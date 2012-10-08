//
//  SignUpModalViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SignUpModalViewController : UIViewController<UIWebViewDelegate>{
    UIWebView *signUpWebView;
    NSMutableData * receivedData;
    NSURL *url;
}

@property(nonatomic,retain)IBOutlet UIWebView *signUpWebView;
@property(nonatomic,retain)IBOutlet UINavigationBar *signUpToolBar;
@property (nonatomic,retain)    AppDelegate *appDel;
@property(nonatomic,retain)  NSMutableData * receivedData;
@property(nonatomic,retain)  NSURL *url;
@property(nonatomic,retain)  UIActivityIndicatorView *loadIndicator;
@property (nonatomic)BOOL signUp;
-(IBAction)cancelbuttonPressed;

@end
