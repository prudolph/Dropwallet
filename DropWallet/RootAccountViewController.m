//
//  RootAccountViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootAccountViewController.h"
#import "AccountDetailViewController.h"

@implementation RootAccountViewController

@synthesize accountSettings;
@synthesize accountDetailViewController;
@synthesize appDel;
@synthesize accountRootTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        self.title =[appDel.appText objectForKey:@"Account_View-Title"]; 
        
        
        self.navigationController.navigationItem.backBarButtonItem.title=@"Back";

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
      

    self.navigationController.navigationBar.topItem.title=@"";

    [self.accountRootTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.accountRootTableView setBackgroundColor:[UIColor whiteColor]];
    self.accountRootTableView.contentOffset=CGPointMake(0, 45);
    
  self.accountSettings =[[NSArray alloc] initWithObjects:
                           [appDel.appText objectForKey:@"Account_Settings-Personal"],
                           [appDel.appText objectForKey:@"Account_Settings-Password"],
                           [appDel.appText objectForKey:@"Account_Settings-Payment"],
                           [appDel.appText objectForKey:@"Account_Settings-Address"],
                         @"Sign Out",nil];
    
    //add Signout Button
   // UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle: @"Sign Out" style: UIBarButtonItemStylePlain target: appDel action: @selector(logout)];
    //  self.navigationItem.rightBarButtonItem=signOutButton;


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:appDel.logoImgView];
    [appDel.logoImgView setHidden:NO];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        UILabel *headerLabel=[[UILabel alloc]init];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        headerLabel.frame=CGRectMake(60, 7.0, 200, 40);
        
        [headerLabel setText:@"ACCOUNT"];    
        
        UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
          headerView.frame=CGRectMake(0, 0, 320.00, 34.0);
        [headerView addSubview:headerLabel ];
        
        return headerView;
    }
    else return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return  40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.accountSettings count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    UIImageView *accountSettingBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AccountButtonsBG.png"]];
     cell.backgroundView=accountSettingBG;
    
    
    
    cell.textLabel.text = [self.accountSettings objectAtIndex:row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:0/255 green:170.0/255 blue:235.0/255 alpha:1.0]];
  
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
    
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath row]==  [self.accountSettings count]-1){
        [appDel logout];
    }
    else{
    self.accountDetailViewController = [[AccountDetailViewController alloc] init];
    self.accountDetailViewController.accountOption = [indexPath row];
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
        [newBackButton setTintColor:[UIColor darkGrayColor]];
        self.navigationItem.backBarButtonItem= newBackButton;
           [self.navigationController pushViewController:self.accountDetailViewController animated:YES];
    }

    [self.accountRootTableView cellForRowAtIndexPath:indexPath].selected =NO;

}



@end
