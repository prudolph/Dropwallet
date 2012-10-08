//
//  TrackingModalWebViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingModalWebViewController.h"


@implementation TrackingModalWebViewController

@synthesize trackingUrl;

@synthesize trackingWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        trackingWebView = [[UIWebView alloc]init];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
// MARK: -
// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* currentString=[NSString stringWithFormat:@"%@",[request URL]];
    
    NSString* logoutString=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/logout"];
    NSString* logoutString1=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/home"];
    if([currentString isEqualToString:logoutString] || [currentString isEqualToString:logoutString1]){
        
        AppDelegate* appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [appDel displayErrorMsgToUserWithTitle:@"You're In!" andMsg:@"Your account is all set up. Please login"];
        [self dismissModalViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  //  [loadIndicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[loadIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   //[loadIndicator stopAnimating];
}

-(IBAction)doneButtonPressed{
    [self.navigationController dismissModalViewControllerAnimated:YES];

}
@end
