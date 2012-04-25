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
@synthesize submitButton,SignUpButton;
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
    
    self.appDel = [[UIApplication sharedApplication]delegate];

    
    // Get username from keychain (if it exists)
	[self.appEmailTextfield setText:[appDel.keychain objectForKey:(__bridge id)kSecAttrAccount]];
    

    // Get password from keychain (if it exists)  
	[self.appPasswordTextfield setText:[appDel.keychain objectForKey:(__bridge  id)kSecValueData]];
   

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)loginSubmit{
    
    if ([self.appEmailTextfield.text length] >0 && 
        [self.appPasswordTextfield.text length] >0) {
       
        //bad way to save credentials
        //[appDel.accountInfo setObject:self.appEmailTextfield.text forKey:@"email"];
        //[appDel.accountInfo setObject:self.appPasswordTextfield.text forKey:@"password"];
 
        // Store username to keychain 	
        [appDel.keychain setObject:self.appEmailTextfield.text forKey:(__bridge id)kSecAttrAccount];
        
 		// Store password to keychain
        [appDel.keychain setObject:self.appPasswordTextfield.text forKey:(__bridge  id)kSecValueData];    	    

#warning pull user data here;
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
  
     missingInfoAlert = [[UIAlertView alloc] initWithTitle:[appDel.appText objectForKey:@"Missing_Login_Info-Title"] 
                        message:[appDel.appText objectForKey:@"Missing_Login_Info-Msg"] delegate:self cancelButtonTitle:[appDel.appText objectForKey:@"Missing_Login_Info-Btn"]
                                         otherButtonTitles: nil];
        
        [missingInfoAlert show];
        
      
    }
    
}

-(IBAction)signUpSelected:(id)sender{
    SignUpModalViewController *signUpView = [[SignUpModalViewController alloc]init];
    [self presentModalViewController:signUpView animated:YES];
//    [self.navigationController presentModalViewController:signUpView animated:YES];
    

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
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
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
