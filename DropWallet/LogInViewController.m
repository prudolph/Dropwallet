//
//  LogInViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 1.2;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


#import "LogInViewController.h"
#import "AppDelegate.h"
@implementation LogInViewController
//appdelegate
@synthesize appDel;

//textfields
@synthesize appEmailTextfield,appPasswordTextfield;

//Alert
@synthesize missingInfoAlert;
//Button
@synthesize submitButton,SignUpButton,savePasswordButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout=YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDel.loadIndicator.frame=CGRectMake(125.0, 225, 45, 45);
    [self.view addSubview: appDel.loadIndicator];
    [appDel.loadIndicator stopAnimating];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Get username from keychain (if it exists)
	[appEmailTextfield setText:[appDel.keychain objectForKey:(__bridge id)kSecAttrAccount]];
    // Get password from keychain (if it exists)  
	[appPasswordTextfield setText:[appDel.keychain objectForKey:(__bridge  id)kSecValueData]];
    
    if(!appDel.saveInfoBOOl)[savePasswordButton setBackgroundImage:[UIImage imageNamed:@"RememberMeIconUnchecked.png"] forState:UIControlStateNormal];
    else[savePasswordButton setBackgroundImage:[UIImage imageNamed:@"RememberMeIcon.png"] forState:UIControlStateNormal];
  
//[appEmailTextfield setText:@"paul.e.rudolph@gmail.com"];
  // [appPasswordTextfield setText:@"Duc620ie"];
    
   [appEmailTextfield setText:@"prudolph@icuetv.com"];
   [appPasswordTextfield setText:@"password"];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)loginSubmit{
 
    Validator *validator = [[Validator alloc]init];
        if([validator isThisValidUsername:self.appEmailTextfield.text andPassWord:self.appPasswordTextfield.text].length==0){
          [submitButton setEnabled:NO];
          [appDel.keychain setObject:self.appEmailTextfield.text forKey:(__bridge id)kSecAttrAccount]; // Store username to keychain 	
          [appDel.keychain setObject:self.appPasswordTextfield.text forKey:(__bridge  id)kSecValueData];// Store password to keychain    	    
          [appDel.loadIndicator startAnimating];
          [appDel checkCredentials];
    }
    else{
        [appDel displayErrorMsgToUserWithTitle:[validator.validationMsgs objectForKey:@"Invalid_UnamePass-Title"] andMsg:[validator isThisValidUsername:self.appEmailTextfield.text andPassWord:self.appPasswordTextfield.text]];
    }
    [submitButton setEnabled:YES];

}

-(IBAction)signUpSelected:(id)sender{
    SignUpModalViewController *signUpView = [[SignUpModalViewController alloc]init];
    signUpView.signUp=YES;
    if ([appDel testConnection]) {
        [self presentModalViewController:signUpView animated:YES];
    }
    else
        [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"No_Conn-Title"] andMsg:[appDel.appText objectForKey:@"No_Conn-Msg"]];
}

-(IBAction)loginOptions:(id)sender{
    if(((UIButton*)sender).tag==5){
        if(appDel.saveInfoBOOl){
                appDel.saveInfoBOOl=NO;
                [savePasswordButton setBackgroundImage:[UIImage imageNamed:@"RememberMeIconUnchecked.png"] forState:UIControlStateNormal];
        }
        else {
            appDel.saveInfoBOOl=YES;
            [savePasswordButton setBackgroundImage:[UIImage imageNamed:@"RememberMeIcon.png"] forState:UIControlStateNormal];
            }
    }    
    if(((UIButton*)sender).tag==6){
        SignUpModalViewController *signUpView = [[SignUpModalViewController alloc]init];
        signUpView.signUp=NO;
        if ([appDel testConnection]) {
            [self presentModalViewController:signUpView animated:YES];
        }
        else
            [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"No_Conn-Title"] andMsg:[appDel.appText objectForKey:@"No_Conn-Msg"]];
    }
    
    
}

#pragma Mark - textfield functions
-(IBAction)backgroundTap:(id)sender{
    [self.appEmailTextfield resignFirstResponder];
    [self.appPasswordTextfield resignFirstResponder];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //get the bounds of the text field and the view
    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    
    //    find the midline
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
        }
    else if (heightFraction > 1.0){
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else{
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
