//
//  LogInViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpModalViewController.h"
@class AppDelegate;
@interface LogInViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>{

    AppDelegate *appDel;
        IBOutlet UIButton *submitButton,*SignUpButton;
 
    UIAlertView *missingInfoAlert;
}

@property (nonatomic,retain) AppDelegate *appDel;

@property (nonatomic,retain) IBOutlet UITextField *appEmailTextfield,*appPasswordTextfield;
@property (nonatomic,retain) IBOutlet UIButton  *submitButton,*SignUpButton;

@property (nonatomic,retain) UIAlertView *missingInfoAlert;

-(IBAction)loginSubmit;
-(IBAction)signUpSelected:(id)sender;

@end
