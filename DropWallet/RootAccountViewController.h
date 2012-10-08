//
//  RootAccountViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LogInViewController.h"

@class AccountDetailViewController;
@interface RootAccountViewController : UIViewController{

    NSArray *accountSettings;
    IBOutlet AccountDetailViewController *accountDetailViewController;
    AppDelegate *appDel;
    IBOutlet UITableView *accountRootTableView;
}

@property (nonatomic,retain) NSArray *accountSettings;
@property (nonatomic,retain) IBOutlet AccountDetailViewController * accountDetailViewController;
@property (nonatomic,retain) AppDelegate *appDel;
@property (nonatomic,retain) IBOutlet UITableView *accountRootTableView;


@end
