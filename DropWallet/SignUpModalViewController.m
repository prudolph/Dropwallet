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
@synthesize appDel;
@synthesize signUpToolBar;
@synthesize signUp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
             }
    return self;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
  
    loadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadIndicator.frame=CGRectMake(135, 22, 50, 50);
    [signUpWebView addSubview:loadIndicator];
    [signUpWebView setScalesPageToFit:YES];
    [signUpWebView setDelegate:self];

    
    [signUpToolBar  setBackgroundImage:[UIImage imageNamed:@"leathernavimage.png"] forBarMetrics:UIBarMetricsDefault];  
    [signUpToolBar addSubview:appDel.logoImgView];

    [appDel.logoImgView setHidden:NO];
    if(signUp)
    url = [NSURL URLWithString:@"https://customer.dropwallet.net/accounts/new"];
    else {
        [self.view setBackgroundColor:[UIColor colorWithRed:123.0/255.0 green:123.0/255.0 blue:123.0/255.0 alpha:1] ];
        url = [NSURL URLWithString:@"https://customer.dropwallet.net/"];
    }
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [signUpWebView loadRequest:request];
    NSLog(@"%@",    signUpWebView.frame.size.height);

    
    
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
  
    NSString* currentString=[NSString stringWithFormat:@"%@",[request URL]];
    NSString* logoutString=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/logout"];
    NSString* logoutString1=[NSString stringWithFormat:@"%@",@"https://customer.dropwallet.net/home"];
    if([currentString isEqualToString:logoutString] || [currentString isEqualToString:logoutString1]){
        
        [self.appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"Success_Login-Title"] andMsg:[appDel.appText objectForKey:@"Success_Login-Msg"]];
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
