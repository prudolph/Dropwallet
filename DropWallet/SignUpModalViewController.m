//
//  SignUpModalViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpModalViewController.h"

@implementation SignUpModalViewController
@synthesize signUpWebView;
@synthesize receivedData,url;
@synthesize loadIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          
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
    loadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadIndicator.frame=CGRectMake(150, 22, 50, 50);
    [signUpWebView addSubview:loadIndicator];
    [signUpWebView setScalesPageToFit:YES];
    [signUpWebView setDelegate:self];

  url = [NSURL URLWithString:@"https://customer.dropwallet.net/accounts/new"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [signUpWebView loadRequest:request];
    
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

// MARK: -
// MARK: UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"nav type %@",[request URL]);
    NSString* currentString=[NSString stringWithFormat:@"%@",[request URL]];
   
    NSString* logoutString=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/logout"];
    NSString* logoutString1=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/home"];
    if([currentString isEqualToString:logoutString] || [currentString isEqualToString:logoutString1]){
        NSLog(@"LInks match");
        AppDelegate* appDel = [[UIApplication sharedApplication]delegate];
        [appDel displayErrorMsgToUserWithTitle:@"You're In!" andMsg:@"Your account is all set up. Please login"];
        [self dismissModalViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [loadIndicator startAnimating];
   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadIndicator stopAnimating];
 }
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [loadIndicator stopAnimating];
}

-(IBAction)cancelbuttonPressed{
    [self dismissModalViewControllerAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
