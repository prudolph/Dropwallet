//
//  RootAccountViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountDetailViewController;
@interface RootAccountViewController : UITableViewController{

    NSArray *accountSettings;
    IBOutlet AccountDetailViewController *accountDetailViewController;
 
}

@property (nonatomic,retain) NSArray *accountSettings;
@property (nonatomic,retain) IBOutlet AccountDetailViewController * accountDetailViewController;
@end
