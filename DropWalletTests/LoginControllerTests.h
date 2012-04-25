//
//  LoginControllerTests.h
//  DropWallet
//
//  Created by Paul Rudolph on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LogInViewController.h"
#import "SignUpModalViewController.h"
@interface LoginControllerTests : SenTestCase{
    
@private
    
    AppDelegate *appDel;
    LogInViewController *loginViewController;
    UIView *loginView;
    SignUpModalViewController* signupViewController;
}
@end