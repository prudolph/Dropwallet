//
//  AddressPickerViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressPickerViewController.h"

#import "AppDelegate.h"
#import "Address.h"
@implementation AddressPickerViewController
@synthesize edit;
@synthesize  addressArray;
@synthesize addressTableViewCell;
@synthesize delegate;
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
    self.title =@"Address Book";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    self.addressArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] addressBook];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    NSUInteger row = [indexPath row];
   static NSString *CellIdentifier=@"AddressCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
        if ([nib count] > 0) { 
            cell = self.addressTableViewCell;
        } else {
            NSLog(@"failed to load MessageCell nib!");
        } 
    }
    UILabel *primaryLabel = (UILabel *)[cell viewWithTag:5];
    primaryLabel.hidden = YES;

    //nameLabel
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10];
    nameLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[self.addressArray objectAtIndex:row]).toName ];
    
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:20];
    addressLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[self.addressArray objectAtIndex:row]).address1 ];
    
    UILabel *cityStateZipLabel = (UILabel *)[cell viewWithTag:30];
    cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", ((Address*)[self.addressArray objectAtIndex:row]).city,((Address*)[self.addressArray objectAtIndex:row]).state,((Address*)[self.addressArray objectAtIndex:row]).zip ];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 90.0;
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
   
    if(edit==NO){
        if ([self.delegate respondsToSelector:@selector(addressSelectedFromAddressBook:)]){
                [self.delegate addressSelectedFromAddressBook:[self.addressArray objectAtIndex:[indexPath row]]];
            //save cc to array
            if ([self.delegate respondsToSelector:@selector(saveCreditcard:)]){
                [self.delegate saveNewCreditCard];
                }
        

            int count = [self.navigationController.viewControllers count];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES];
     
        }
    }
        else{
           
            if ([self.delegate respondsToSelector:@selector(addressSelectedFromAddressBook:)]){
                [self.delegate addressSelectedFromAddressBook:[self.addressArray objectAtIndex:[indexPath row]]];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            
}


@end
