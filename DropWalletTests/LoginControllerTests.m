//
//  LoginControllerTests.m
//  DropWallet
//
//  Created by Paul Rudolph on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginControllerTests.h"

@implementation LoginControllerTests

- (void)setUp
{
    [super setUp];

   appDel =                 [[UIApplication sharedApplication] delegate]; 
   loginViewController =    [[LogInViewController alloc]init];
   loginView=               loginViewController.view;
     signupViewController = [[SignUpModalViewController alloc]init];
}

-(void) testDelegate_ViewController{
       STAssertNotNil(appDel, @"Cannot find the application delegate");
       STAssertNotNil(loginViewController, @"Cannot find the loginViewController");
}
-(void)testLoginWithEmptyFields{

    [loginViewController loginSubmit];
    
   // STAssertTrue([loginViewController.missingInfoAlert isVisible], @"");
[loginViewController.missingInfoAlert dismissWithClickedButtonIndex:1 animated:NO];
    

}
-(void)testLoginWithUname{
    STAssertFalse([loginViewController.missingInfoAlert isVisible], @"");
    [loginViewController.appEmailTextfield setText:@"UserName"]; 
    
    [loginViewController loginSubmit];

   // STAssertTrue([loginViewController.missingInfoAlert isVisible], @"");
    
}
-(void)testLoginWithCreds{
    [loginViewController.appEmailTextfield setText:@"UserName"]; 
    [loginViewController.appPasswordTextfield setText:@"Password"]; 
    
    [loginViewController loginSubmit];
    
    NSLog(@"Root Views: %@",[appDel.window.rootViewController view]);
   //STAssertTrue( , @"");
    
}

- (void)tearDown
{
    // Tear-down code here.
    signupViewController =nil;
    loginView=nil;
    loginViewController = nil;
    appDel = nil;
    [super tearDown];
}


@end
