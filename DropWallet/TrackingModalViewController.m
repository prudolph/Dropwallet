//
//  TrackingModalViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingModalViewController.h"



@implementation TrackingModalViewController
@synthesize urlString;
@synthesize trackingToolBar;
@synthesize loadIndicator;
@synthesize appDel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UIWebView *webview=[[UIWebView alloc] initWithFrame:CGRectMake(0.0,44.0,320.0,416.0)];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    webview.delegate = self;
    [webview loadRequest:requestObj];
  
    loadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadIndicator.frame=CGRectMake(125, 50, 50, 50);
    loadIndicator.color = [UIColor blueColor];
    [webview addSubview:loadIndicator];

    
    [self.view addSubview:webview];
   
    [trackingToolBar  setBackgroundImage:[UIImage imageNamed:@"leathernavimage.png"] forBarMetrics:UIBarMetricsDefault];  
    [trackingToolBar addSubview:appDel.logoImgView];
    [appDel.logoImgView setHidden:NO];
    
    if([urlString rangeOfString:@"ups"].location != NSNotFound)//if its ups 
        self.view.backgroundColor =[UIColor colorWithRed:51.0f/255 green:0 blue:0 alpha:1];//ups color
    else if([urlString rangeOfString:@"fedex"].location != NSNotFound)//if its ups    
         self.view.backgroundColor =[UIColor colorWithRed:247.0f/255 green:247.0f/255 blue:247.0f/255 alpha:1];//fedex
    else if([urlString rangeOfString:@"usps"].location != NSNotFound)//if its ups    
        self.view.backgroundColor =[UIColor colorWithRed:237.0f/255 green:237.0f/255 blue:239.0f/255 alpha:1];//fedex
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {     
    [loadIndicator startAnimating];       
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadIndicator stopAnimating];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)doneButtonSelected:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
@end
