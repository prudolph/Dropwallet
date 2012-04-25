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
@synthesize navBar,backButton;
@synthesize currentOrder;
//lables
@synthesize subTotalLBL,taxLBL,shipLBL,statusLBL,totalLBL;


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

    self.title=[NSString stringWithFormat:@"%@",self.currentOrder.purchaseDate];
    subTotalLBL.text=[NSString stringWithFormat:@"%.2f",self.currentOrder.orderSubTotal];
    shipLBL.text=[NSString stringWithFormat:@"%.2f",self.currentOrder.orderShippingTotal];
    totalLBL.text=[NSString stringWithFormat:@"%.2f",self.currentOrder.orderTotal];
    statusLBL.text = self.currentOrder.orderStatus;
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

#pragma Mark - Table View 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{   
    return [self.currentOrder.items count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    NSUInteger row = [indexPath row];
    
    //set item image    
    UIImageView *itemImage = (UIImageView *)[cell viewWithTag:40];
    [itemImage setImage:(UIImage*)[((Item*)[self.currentOrder.items objectAtIndex:row]) itemImage]];  
 
    //set productname
    UILabel *itemNameLabel = (UILabel *)[cell viewWithTag:10]; 
    itemNameLabel.text = [((Item*)[self.currentOrder.items objectAtIndex:row]) itemDesc ];
    
    //set Qty
    UILabel *itemQtyLabel = (UILabel *)[cell viewWithTag:20]; 
  itemQtyLabel.text = [ NSString stringWithFormat:@"%d",[((Item *)[self.currentOrder.items objectAtIndex:row])qtyPurchased]];
   
    //set price
    UILabel *itemPriceLabel = (UILabel *)[cell viewWithTag:30]; 
    itemPriceLabel.text = [ NSString stringWithFormat:@"$%.2f",[((Item *)[self.currentOrder.items objectAtIndex:row])price]];

    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}

#pragma mark - Nav functions

-(IBAction)backbuttonPressed:(id)sender{
    NSLog(@"BackButton Pressed");
    [self dismissModalViewControllerAnimated:YES];
    
}



@end
