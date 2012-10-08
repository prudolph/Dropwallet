//
//  OrderDetailViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Item.h"
#define SUBTOTAL_LBL 10
#define TAX_LBL 20
#define SHIP_LBL 30
#define STATUS_LBL 40
#define TOTAL_LBL 50


@implementation OrderDetailViewController
@synthesize orderTableView;
@synthesize itemCell;
@synthesize orderFooterView;

@synthesize currentOrder;
//lables
@synthesize subTotalLBL,taxLBL,shipLBL,statusLBL,totalLBL;
@synthesize appDel;

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


    [self.view addSubview:orderTableView];
    
    self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    

    self.title=@"Activity";
    //set the navbar title to color and text

    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor=[UIColor lightGrayColor];
    titleLabel.text=self.title;
    [self.navigationItem.titleView addSubview:titleLabel];
    
    subTotalLBL.text=[NSString stringWithFormat:@"%.2f",self.currentOrder.orderSubTotal];
    shipLBL.text=   [NSString stringWithFormat:@"%.2f",self.currentOrder.orderShippingTotal];
    totalLBL.text=  [NSString stringWithFormat:@"$%.2f",self.currentOrder.orderTotal];
    statusLBL.text = self.currentOrder.orderStatus;
    [appDel.logoImgView setHidden:YES];
    
    //add Signout Button
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle: @"Sign Out" style: UIBarButtonItemStylePlain target: appDel action: @selector(logout)];
    self.navigationItem.rightBarButtonItem=signOutButton;
   
}

-(void)viewWillAppear:(BOOL)animated{
     
    [super viewWillAppear:animated];
        [orderTableView reloadData];
     
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   }

  - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Mark - Table View 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    headerView.backgroundColor =[UIColor yellowColor];
   
    UILabel *headerLabel=[[UILabel alloc]init];
        headerLabel.frame=CGRectMake(0, 6.0, 320, 35);
        headerLabel.textAlignment=UITextAlignmentCenter;
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        [headerLabel setText:@"ORDER DETAILS"];    
        
        UIImageView *headerImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
        headerImgView.frame=CGRectMake(0, 0, 320.00, 35.0);
        [headerImgView addSubview:headerLabel ];
     
    [headerView addSubview:headerImgView];
    return headerView;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{   
    if(section==0)
            return [self.currentOrder.items count]+1;//extra cell for order info at the top 
    if(section==1)
        return 1;
    if(section==2)
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0)
        return 30.0;
    return 90.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        NSUInteger row = [indexPath row];
 
    if(row==0){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:self.currentOrder.purchaseDate];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        [dateFormatter stringFromDate:date];

        UITableViewCell * purchaseDateCell=[[UITableViewCell alloc]init];
        UILabel * orderDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 5.0, 320, 20.0)];

        orderDate.textAlignment=UITextAlignmentCenter;
        [orderDate setText: [NSString stringWithFormat:@"Order #: %@   |   %@",self.currentOrder.orderNumber,[dateFormatter stringFromDate:date]]]; 
        [orderDate setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17.0f]];
        [orderDate setTextColor:[UIColor colorWithRed:28.0/255.0 green:171.0/255.0 blue:232.0/255.0 alpha:1.0]];
        [orderDate setBackgroundColor:[UIColor clearColor]];
        [purchaseDateCell addSubview:orderDate];
        
        UILabel *orderTime =[[UILabel alloc]initWithFrame:CGRectMake(0, -22, 320, 20.0)];
  
        [dateFormatter setDateFormat:@"hh:mm a"];
        [orderTime setText: [NSString stringWithFormat:@"Ordered @ %@",[dateFormatter stringFromDate:date],self.currentOrder.orderTotal]]; 
        [orderTime setFont:[UIFont fontWithName:@"ArialMT" size:11.0f]];
        [orderTime setTextAlignment:UITextAlignmentCenter];
        [orderTime setTextColor:[UIColor grayColor]];
        [orderTime setBackgroundColor:[UIColor clearColor]];
     
        [[self.view.subviews objectAtIndex:0] addSubview:orderTime];
   
        purchaseDateCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return purchaseDateCell;
    }
     else {
    
    static NSString *batchTableIdentifier = @"ItemCellIdentifier";
    UITableViewCell *cell = [self.orderTableView dequeueReusableCellWithIdentifier: batchTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
        if ([nib count] > 0) { 
            cell = self.itemCell;
        } else {
            NSLog(@"failed to load MessageCell nib!");
        } 
    }
    
       
    
    //set item image    
    UIImageView *itemImage = (UIImageView *)[cell viewWithTag:40];
    if(![[((Item*)[self.currentOrder.items objectAtIndex:row-1]) itemImage]isEqual:@"*"])
    [itemImage setImage:(UIImage*)[((Item*)[self.currentOrder.items objectAtIndex:row-1]) itemImage]];  
 
    //set productname
    UILabel *itemNameLabel = (UILabel *)[cell viewWithTag:10]; 
    itemNameLabel.text = [((Item*)[self.currentOrder.items objectAtIndex:row-1]) itemName ];
    
    //set Qty
    UILabel *itemQtyLabel = (UILabel *)[cell viewWithTag:20]; 
    itemQtyLabel.text = [ NSString stringWithFormat:@"%d",[((Item *)[self.currentOrder.items objectAtIndex:row-1])qtyPurchased]];
   
    //set price
    UILabel *itemPriceLabel = (UILabel *)[cell viewWithTag:30]; 
    itemPriceLabel.text = [ NSString stringWithFormat:@"$%.2f",[((Item *)[self.currentOrder.items objectAtIndex:row-1])price]];
    
    //set Status
    UILabel *itemStatusLabel = (UILabel *)[cell viewWithTag:50]; 
        NSString *status;
        if([[((Item *)[self.currentOrder.items objectAtIndex:row-1])status] isEqualToString:@""])
            status= @"...";
        else 
            status = [NSString stringWithFormat:@"%@",((Item *)[self.currentOrder.items objectAtIndex:row-1]).status];
    itemStatusLabel.text =[NSString stringWithFormat:@"%@", status];

        UIScrollView * itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 75)];
        [itemScrollView setPagingEnabled:YES];
        [itemScrollView addSubview:cell];
    
    //open tracking button
        
        UILabel *trackingLbl = (UILabel*)[cell viewWithTag:90];
        
        UIButton *trackingButton = (UIButton*)[cell viewWithTag:91];
        [trackingButton addTarget:self action:@selector(displayTrackingInfo:) forControlEvents:UIControlEventTouchUpInside];
       
        if([[((Item *)[self.currentOrder.items objectAtIndex:row-1]).shippingUrls allKeys]count]>0){
              [trackingButton setTitle:[NSString stringWithFormat:@"%@",[[((Item *)[self.currentOrder.items objectAtIndex:row-1]).shippingUrls allKeys]objectAtIndex:0]] forState:UIControlStateNormal];
            
            NSLog(@"TRACKING INFO %@",((Item *)[self.currentOrder.items objectAtIndex:row-1]).shippingUrls );
            
            NSString *trackingUrl = [NSString stringWithFormat:@"%@",[[((Item *)[self.currentOrder.items objectAtIndex:row-1]).shippingUrls allValues]objectAtIndex:0]];
            
       
            if([trackingUrl rangeOfString:@"FedEx"].location != NSNotFound)
                trackingLbl.text = @"FedEx:";
            else  if([trackingUrl rangeOfString:@"ups"].location != NSNotFound)
               trackingLbl.text = @"UPS:";
            else  if([trackingUrl rangeOfString:@"USPS"].location != NSNotFound)
                trackingLbl.text = @"USPS:";
            else {
                 trackingLbl.text = @"Track:";
            }
            
        }
        else {
            [trackingButton setHidden:YES];
            [trackingLbl setHidden:YES];
            
        }
        
        
        
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
      return cell;
    }
    
  
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 UIView *orderInfo=   [orderFooterView viewWithTag:100];
    
    [((UILabel*)[orderInfo viewWithTag:1]) setText:[ NSString stringWithFormat:@"%@", self.currentOrder.orderAddress.toName]];
    [((UILabel*)[orderInfo viewWithTag:2]) setText:[ NSString stringWithFormat:@"%@", self.currentOrder.orderAddress.address1]];
    [((UILabel*)[orderInfo viewWithTag:3]) setText:[ NSString stringWithFormat:@"%@", self.currentOrder.orderAddress.address2]];
    [((UILabel*)[orderInfo viewWithTag:4]) setText:[ NSString stringWithFormat:@"%@ , %@ %@", self.currentOrder.orderAddress.city,self.currentOrder.orderAddress.state,self.currentOrder.orderAddress.zip]];
    [((UILabel*)[orderInfo viewWithTag:5]) setText:[ NSString stringWithFormat:@"%@", self.currentOrder.paymentInfo]];
  
    
    UIView *orderTotals=   [orderFooterView viewWithTag:200];   
    [((UILabel*)[orderTotals viewWithTag:60]) setText:[ NSString stringWithFormat:@"$%.2f", self.currentOrder.orderSubTotal]] ;
    [((UILabel*)[orderTotals viewWithTag:70]) setText:[ NSString stringWithFormat:@"$%.2f", self.currentOrder.orderShippingTotal]] ;
    [((UILabel*)[orderTotals viewWithTag:80]) setText:[ NSString stringWithFormat:@"$%.2f", self.currentOrder.orderTaxTotal]] ;
    [((UILabel*)[orderTotals viewWithTag:90]) setText:[ NSString stringWithFormat:@"$%.2f", self.currentOrder.orderTotal]] ;


    // check items to see if they are cancelled   
    int cancelledCount = 0;
    for (Item *i in self.currentOrder.items){
        if ([i.status isEqualToString:@"Cancelled"]) {
            cancelledCount++;
        }
    }
    //if shipped to address does not have address line 2
    if([self.currentOrder.orderAddress.address2 isEqualToString:@""]){
       [orderInfo viewWithTag:6].frame = CGRectMake(10, 40, 300, 70);
       [orderInfo viewWithTag:1].frame = CGRectMake(20, 45, 93, 21);
       [orderInfo viewWithTag:2].frame = CGRectMake(20, 65, 170, 21);
        [orderInfo viewWithTag:4].frame = CGRectMake(20, 85 , 170, 21);
        
        
        for(int i=7;i<10;i++){
         [orderInfo viewWithTag:i].frame = CGRectMake([orderInfo viewWithTag:i].frame.origin.x,
                                                      [orderInfo viewWithTag:i].frame.origin.y-20,
                                                      [orderInfo viewWithTag:i].frame.size.width,
                                                      [orderInfo viewWithTag:i].frame.size.height);
        }
        orderTotals.frame=CGRectMake(0, 215, 320, 130);
        
         }
    
    if((self.currentOrder.orderAddress.toName==NULL &&
       self.currentOrder.orderAddress.address1==NULL &&
       self.currentOrder.orderAddress.city==NULL &&
       self.currentOrder.orderAddress.state==NULL &&
       self.currentOrder.orderAddress.zip==NULL)||cancelledCount==[currentOrder.items count]){
        orderInfo.hidden=YES;
        orderTotals.frame = CGRectMake(0, 5, 320, 130);
        
    }
       
    UIView *cancelView = [orderFooterView viewWithTag:300];
    [((UIButton*)[cancelView viewWithTag:301]) addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    
    if(!currentOrder.cancelable){
        cancelView.hidden=YES;
        orderInfo.frame=CGRectMake(orderInfo.frame.origin.x, 
                                   orderInfo.frame.origin.y-(cancelView.frame.size.height-15),
                                   orderInfo.frame.size.width,
                                   orderInfo.frame.size.height);
        orderTotals.frame=CGRectMake(orderTotals.frame.origin.x, 
                                     orderTotals.frame.origin.y-(cancelView.frame.size.height-35),
                                     orderTotals.frame.size.width,
                                     orderTotals.frame.size.height);
    }
     return orderFooterView;
   }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 365.0;
}

-(void)displayTrackingInfo:(id)sender{

    int x= ((UIButton*)sender).frame.size.width;
    int y=((UIButton*)sender).frame.size.height;
    
    Item *currentItem = ((Item*)[currentOrder.items objectAtIndex:[orderTableView indexPathForRowAtPoint:CGPointMake(x,y)].row]);
    TrackingModalViewController * trackingModalWebViewController = [[TrackingModalViewController alloc]init];
    trackingModalWebViewController.urlString =   [[currentItem.shippingUrls allValues] objectAtIndex:0];
    
    [self.navigationController presentModalViewController:trackingModalWebViewController animated:YES];
}

-(void)cancelOrder{
    UIAlertView *confirmCancel= [[UIAlertView alloc]initWithTitle:@"Confirm Cancel" message:@"Are you sure you want to cancel this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [confirmCancel show];
  
}
#pragma mark - Nav functions

-(IBAction)backbuttonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
       [[self.view.subviews objectAtIndex:0] addSubview: appDel.loadIndicator];
        [appDel.loadIndicator startAnimating];
        [appDel cancelOrder:currentOrder.orderNumber];
    }
}

@end
