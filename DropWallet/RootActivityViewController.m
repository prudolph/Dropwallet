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

@synthesize orderDetailViewController;
@synthesize purchasesTableView,orderCell;
@synthesize purchases;
@synthesize tapgr;
@synthesize appDel;
@synthesize noContentView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.appDel = [[UIApplication sharedApplication]delegate];

    self.title=@"Activity";
    
  
   
    //Order 1 
    Item *sharkweek = [[Item alloc] initWithItemDesc:@"Sharkweek- DVD Collection" 
                                              itemID:@"123456" 
                                               price:@"13.99" 
                                        qtyPurchased:@"3" 
                                           itemImage:[UIImage imageNamed:@"Sharkweekdvd.jpeg"]];
    
    Item *jergens = [[Item alloc] initWithItemDesc:@"Jergens" 
                                            itemID:@"99991" 
                                             price:@"13.99" 
                                      qtyPurchased:@"1" 
                                         itemImage:[UIImage imageNamed:@"jergens.jpeg"]];
    
    
    Item *rings = [[Item alloc] initWithItemDesc:@"Rings" 
                                          itemID:@"5550" 
                                           price:@"13.99" 
                                    qtyPurchased:@"1" 
                                       itemImage:[UIImage imageNamed:@"ring.jpeg"]];
    NSArray *objects = [[NSArray alloc] initWithObjects:sharkweek,rings,jergens,nil];
    
    Order *orderOne = [[Order alloc] initWithOrderNumber:@"123" 
                                             orderStatus:@"Completed" 
                                            purchaseDate:@"12/02/2011" 
                                                   items:objects 
                                           shippingTotal:@"195.99" ];
    
    
   
    
    NSArray *objects_2 = [[NSArray alloc] initWithObjects:rings, nil];
    
    Order *orderTwo = [[Order alloc] initWithOrderNumber:@"1235" orderStatus:@"Completed" purchaseDate:@"02/02/2012" items:objects_2 shippingTotal:@"37.99" ];
        objects_2 = [[NSArray alloc] initWithObjects:rings,jergens, nil];
    Order *order = [[Order alloc] initWithOrderNumber:@"5246" orderStatus:@"Sent" purchaseDate:@"04/15/2012" items:objects_2 shippingTotal:@"23.54"];
    
    purchases = [[NSMutableArray alloc] init];
    [purchases addObject:orderOne];
    [purchases addObject:orderTwo];
     [purchases addObject:order];
    
    if([purchases count]==0){
        purchasesTableView.hidden=YES;
        [self.view addSubview:noContentView];
            }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.purchasesTableView = nil;
    self.orderCell =nil;
    self.purchasesTableView =nil;
    self.orderDetailViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UITableViewCell *cell in [self.tableView visibleCells]){
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        // Return the number of sections.
        return 1;
    }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [purchases count];
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
    

    
    NSUInteger row = [indexPath row]; 
    //set purchase date
    UILabel *purchDateLabel = (UILabel *)[cell viewWithTag:10]; 
    purchDateLabel.text = [[purchases objectAtIndex:row] purchaseDate];
    
    //set Item qty
    UILabel *itemQtyLabel = (UILabel *)[cell viewWithTag:20]; 
    itemQtyLabel.text = [NSString stringWithFormat:@"%d", [[[purchases objectAtIndex:row]items] count] ];
    
    //set total  
    UILabel *orderTotalLabel = (UILabel *)[cell viewWithTag:30]; 
    orderTotalLabel.text = [NSString stringWithFormat:@"%.2f", [[purchases objectAtIndex:row] orderTotal]];
    
   
    ScrollingImage *orderScrollImage = [[ScrollingImage alloc]initWithImages:(NSArray*)((Order*)[purchases objectAtIndex:row]).orderImageStack];
    orderScrollImage.frame=CGRectMake(15.0, 4.0, 85.0, 80.0);
    orderScrollImage.tag=40;
    tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapsOnScrollView:)];
    tapgr.delegate = self;
    [orderScrollImage addGestureRecognizer:tapgr];
    [cell addSubview:orderScrollImage];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    
   //Load OrderDetail View
    
    orderDetailViewController = [[OrderDetailViewController alloc] init];
    orderDetailViewController.currentOrder = [[Order alloc]init];
    orderDetailViewController.currentOrder = [purchases objectAtIndex:row];
    [self.navigationController pushViewController:self.orderDetailViewController animated:YES];
    
   
    
    
}

-(void)handleTapsOnScrollView:(id)sender{

   // stop other views from moving
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [((ScrollingImage *)[cell viewWithTag:40]).timer invalidate];
    } 
    [(ScrollingImage*)[sender view] startScrollcycle:NULL];
    
}


@end
