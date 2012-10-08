//
//  RootActivityViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootActivityViewController.h"
#import "OrderDetailViewController.h"
#import "Item.h"
#import "Order.h"

@implementation RootActivityViewController

@synthesize orderScrollImage;
@synthesize orderDetailViewController;
@synthesize purchasesTableView,orderCell;
@synthesize currentOrders;
@synthesize tapgr;
@synthesize appDel;
@synthesize timestamp;
@synthesize nocontentImageView,backgroundImageview;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
       // backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProductButtonBG.png"]];
        
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
    self.title=@"Activity";
    self.navigationController.navigationBar.topItem.title=@"";

    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle: @"Sign Out" style: UIBarButtonItemStylePlain target: appDel action: @selector(logout)];
    
    self.navigationItem.rightBarButtonItem=signOutButton;


    NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"hh:mm:ss a"];
    timestamp = [[UILabel alloc]initWithFrame:CGRectMake(97.5, 65.0, 125.0, 25)];
    timestamp.text=[NSString stringWithFormat:@"Updated @ %@ ",[dateformatter stringFromDate:[NSDate date]]] ;
    timestamp.textAlignment = UITextAlignmentCenter;
    [timestamp setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
    [timestamp setTextColor:[UIColor grayColor]];
    [timestamp setBackgroundColor:[UIColor clearColor]];
    
    
 
    [self.navigationController.view insertSubview:timestamp atIndex:0];
       self.purchasesTableView.backgroundColor=[UIColor clearColor];
      
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.purchasesTableView = nil;
    self.orderCell =nil;
    self.orderDetailViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
 [super viewDidAppear:animated];
    [self.purchasesTableView reloadData];
    [self reloadImages];

    
    //title logo
    [self.navigationController.navigationBar addSubview:appDel.logoImgView];
    [appDel.logoImgView setHidden:NO];
    
    
    // add nocontent view to view
    nocontentImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"NoActivityImage%d.png",arc4random()%8]]];
    nocontentImageView.frame=CGRectMake(0, 0, 320, 387);

  
    if([appDel.orders count]==0)
    self.view = nocontentImageView;
    else {
        self.view=purchasesTableView;
    }
    
    // add pull to refresh to nav view
    UIImageView *pulltoRefresh = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PullDwnScrn.png"]];
    pulltoRefresh.frame = CGRectMake(80.0, 115.0, 158.0 ,45);
    [self.navigationController.view insertSubview:pulltoRefresh atIndex:0];

}

- (void)viewDidAppear:(BOOL)animated{
    [self.purchasesTableView reloadData];
    [self reloadImages];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UITableViewCell *cell in [self.purchasesTableView visibleCells]){
    [((ScrollingImage *)[cell viewWithTag:40]).timer invalidate];
    } 
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
-(void)reloadImages{
  
    for(Order* o in appDel.orders){         
        [o organizeImageStack];
    }

    [self.purchasesTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self.purchasesTableView reloadData];
    

}

#pragma mark - Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        UILabel *headerLabel=[[UILabel alloc]init];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        headerLabel.frame=CGRectMake(0, 8.0, 320, 35);
        headerLabel.textAlignment=UITextAlignmentCenter;
        [headerLabel setText:@"ACTIVITY"];    
        
        UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
       headerView.frame=CGRectMake(0, 5, 320.00, 35.0);
        [headerView addSubview:headerLabel ];
        
        return headerView;
    }
    else return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        // Return the number of sections.
        return 1;
    }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(appDel.orderCurrentPage <appDel.orderPages-1)
       return [appDel.orders count]+1; 
    return [appDel.orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *batchTableIdentifier = @"orderCellIdentifier";
    UITableViewCell *cell = [self.purchasesTableView dequeueReusableCellWithIdentifier: batchTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil];
        if ([nib count] > 0) { 
            cell = self.orderCell;
        } else {
            NSLog(@"failed to load MessageCell nib!");
        } 
    }
       // [[cell viewWithTag:60] setHidden:YES];
        //[[cell viewWithTag:40] removeFromSuperview];
    
        if([indexPath row]==[appDel.orders count] ){
            cell=[[UITableViewCell alloc]init];
            UILabel *moreOrdersLBL=[[UILabel alloc]init];
            moreOrdersLBL.frame=CGRectMake(40, 10, 250, 20);
            moreOrdersLBL.textColor=[UIColor colorWithRed:28.0/255.0 green:171.0/255.0 blue:232.0/255.0 alpha:1.0];
            moreOrdersLBL.backgroundColor=[UIColor clearColor];
            moreOrdersLBL.text=@"Get More Orders...";
           [cell addSubview:moreOrdersLBL];

            UIImageView *getMoreButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GetMoreButton.png"]];
            getMoreButton.frame=CGRectMake(20, 12, 16.0, 18.0); 
           
                    [cell addSubview:getMoreButton];

            
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
                return cell;
        }
    
    NSUInteger row = [indexPath row]; 
      
    //set purchase date
    UILabel *purchDateLabel = (UILabel *)[cell viewWithTag:10]; 
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[[appDel.orders objectAtIndex:row] purchaseDate]];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    [dateFormatter stringFromDate:date];
    purchDateLabel.text =[dateFormatter stringFromDate:date];
    
    //set Item qtyx
    UILabel *OrderNum = (UILabel *)[cell viewWithTag:20]; 
    OrderNum.text = [NSString stringWithFormat:@"Order #: %@", ((Order*)[appDel.orders objectAtIndex:row]).orderNumber];
    
    //set total  
    UILabel *orderTotalLabel = (UILabel *)[cell viewWithTag:30]; 
    orderTotalLabel.text = [NSString stringWithFormat:@"%.2f", [[appDel.orders objectAtIndex:row] orderTotal]];
 
     if(((Order*)[appDel.orders objectAtIndex:row]).scrollimage.kNumImages>0){
         [((UIButton*) [cell viewWithTag:60]) setBackgroundImage:((Item*)[((Order*)[appDel.orders objectAtIndex:row]).items objectAtIndex:0]).itemImage  forState:UIControlStateNormal ];
         ((UIButton*)  [cell viewWithTag:60]).layer.cornerRadius = 11;
         ((UIButton*)  [cell viewWithTag:60]).layer.masksToBounds = YES;
         [((UIButton*) [cell viewWithTag:60]).layer setBorderColor:[[UIColor grayColor]CGColor]];
         [((UIButton*) [cell viewWithTag:60]).layer setBorderWidth:.5];
         [((UIButton*) [cell viewWithTag:60]) setHidden:NO];
         [((UIButton*) [cell viewWithTag:60]) addTarget:self action:@selector(imageWasTouched:) forControlEvents:UIControlEventTouchDown];
         
         [[cell viewWithTag:45] removeFromSuperview];
             }
    
         else {
             
             UIImageView *noImageYet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageNotAvailable.png"]];
             noImageYet.frame = CGRectMake(220.0,5, 77.0, 77.0);
             noImageYet.tag=45;
             if(![cell.subviews containsObject:[cell viewWithTag:45]]){
                 [cell addSubview:noImageYet];
                 [[cell viewWithTag:60] setHidden:YES];
                 [[cell viewWithTag:40] setHidden:YES];
             }      

     }
   
   [cell setUserInteractionEnabled:YES];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ProductButtonBG.png"]];
    backgroundImageView.frame =CGRectMake(0, 0, 300, 90.0);
 
    if(!cell.backgroundView){
        cell.backgroundView = [[UIView alloc]init];
        cell.backgroundColor=[UIColor whiteColor];
    }
    if([cell.backgroundView.subviews count]==0||!cell.backgroundView)
    [cell.backgroundView addSubview:backgroundImageView];
      cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==[appDel.orders count])
        return 44;
    return 90;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ROW HAS BEEN CLICKED");
    NSUInteger row = [indexPath row];
    [[self.purchasesTableView cellForRowAtIndexPath:indexPath] setUserInteractionEnabled:NO];

    // if the last button "get more orders button"is clicked
    if(row ==[appDel.orders count]){
        if(appDel.orderCurrentPage <appDel.orderPages){
            appDel.orderCurrentPage++;
            [appDel loadOrders];
                        }
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];

        }
    else{
   // otherwise Load  the OrderDetail View
        [appDel getSpecificOrder:((Order*)[appDel.orders objectAtIndex:[indexPath row]])];
        orderDetailViewController = [[OrderDetailViewController alloc] init];
        orderDetailViewController.currentOrder = [[Order alloc]init];
        orderDetailViewController.currentOrder = [appDel.orders objectAtIndex:row];
        
        
         UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
        [[self navigationItem] setBackBarButtonItem: newBackButton];
        
        
        if( orderDetailViewController.currentOrder.individuallyUpdated || [appDel SYSdemo])
        [self.navigationController pushViewController:self.orderDetailViewController animated:YES];

    }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
     if(scrollView.contentOffset.y<-75){
    
        [appDel.loadIndicator startAnimating];
         appDel.loadIndicator.frame=CGRectMake(145, 75, 25, 25);
        [self.navigationController.view insertSubview:appDel.loadIndicator atIndex:0];
        appDel.orderCurrentPage=0;
        [appDel loadOrders];
        
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"hh:mm:ss a"];
        timestamp.text=[NSString stringWithFormat:@"Updated @ %@ ",[dateformatter stringFromDate:[NSDate date]]] ;
    }
}

-(void)handleTapsOnScrollView:(id)sender{
 
   // stop other views from moving
    for (UITableViewCell *cell in [self.purchasesTableView visibleCells]){
        [((ScrollingImage *)[cell viewWithTag:40]).timer invalidate];
    } 
    [(ScrollingImage*)[sender view] startScrollcycle:nil];
    
}

-(IBAction)imageWasTouched:(id)sender{
    //NEw Image is clicked set all other scrollimages back to uibutton
    for(UITableViewCell * tbc in [self.purchasesTableView visibleCells] ){
        if([tbc viewWithTag:40]){
            [[tbc viewWithTag:40] removeFromSuperview];
            [tbc viewWithTag:60].hidden=NO;
        }
    }
    
    ((UIButton*)sender).hidden=YES;

    NSIndexPath * cellPath =((UITableViewCell*)[self.purchasesTableView indexPathForCell:[sender superview].superview]) ;

    tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsOnScrollView:)];
    tapgr.delegate = self;
    
    ((Order*)[appDel.orders objectAtIndex:[cellPath row]]).scrollimage.frame = CGRectMake(217.0,8, 70.0, 70.0);
    ((Order*)[appDel.orders objectAtIndex:[cellPath row]]).scrollimage.tag=40;
    [((Order*)[appDel.orders objectAtIndex:[cellPath row]]).scrollimage addGestureRecognizer:tapgr];
    [[sender superview] addSubview:    ((Order*)[appDel.orders objectAtIndex:[cellPath row]]).scrollimage];
    // [((Order*)[appDel.orders objectAtIndex:[cellPath row]]).scrollimage startScrollcycle:nil];
    
     }

@end
