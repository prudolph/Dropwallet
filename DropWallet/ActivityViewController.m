//
//  ViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityViewController.h"
#import "OrderDetailViewController.h"
#import "Item.h"
#import "Order.h"

@implementation ActivityViewController

//@synthesize orderDetailViewController;
@synthesize purchasesTableView,orderCell;
@synthesize purchases;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    NSArray *objects = [[NSArray alloc] initWithObjects:sharkweek,jergens, nil];
    
    Order *orderOne = [[Order alloc] initWithOrderNumber:@"123" 
                                             orderStatus:@"Completed" 
                                            purchaseDate:@"12/02/2011" 
                                                   items:objects 
                                           shippingTotal:@"195.99" ];
    
    
    
    //Order2{
    Item *rings = [[Item alloc] initWithItemDesc:@"Rings" 
                                          itemID:@"5550" 
                                           price:@"13.99" 
                                    qtyPurchased:@"1" 
                                       itemImage:[UIImage imageNamed:@"ring.jpeg"]];
    
    NSArray *objects_2 = [[NSArray alloc] initWithObjects:rings, nil];
    
    Order *orderTwo = [[Order alloc] initWithOrderNumber:@"1235" orderStatus:@"Completed" purchaseDate:@"02/02/2012" items:objects_2 shippingTotal:@"37.99" ];
    
    purchases = [[NSMutableArray alloc] init];
    [purchases addObject:orderOne];
    [purchases addObject:orderTwo];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -TableView

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

    //set order image    
    UIImageView *orderImage = (UIImageView *)[cell viewWithTag:40];
    [orderImage setImage:(UIImage*)((Order*)[purchases objectAtIndex:row]).orderImageStack];  
    
    
    return cell;
}
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
      //Load OrderDetail View
    
    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
    orderDetailViewController.currentOrder = [[Order alloc]init];
    orderDetailViewController.currentOrder = [purchases objectAtIndex:row];

 
    [self presentModalViewController:orderDetailViewController animated:YES];
    
 
}


@end
