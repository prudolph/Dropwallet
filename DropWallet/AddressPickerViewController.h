//
//  AddressPickerViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemViewController.h"
@interface AddressPickerViewController : UITableViewController<EditAddressViewControllerDelegate>{
    BOOL edit;
    NSArray *addressArray;
    IBOutlet UITableViewCell *addressTableViewCell;
}
@property (nonatomic) BOOL edit;
@property (nonatomic,retain) NSArray *addressArray;
@property (nonatomic,retain) IBOutlet UITableViewCell *addressTableViewCell;
@property (nonatomic, unsafe_unretained) id<EditAddressViewControllerDelegate> delegate;

@end
