//
//  OrderDetailViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface OrderDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *orderTableView;
    IBOutlet UITableViewCell *itemCell;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UINavigationItem *navBar;
    Order *currentOrder;
    IBOutlet UILabel *subTotalLBL,*taxLBL,*shipLBL,*statusLBL,*totalLBL;
    
}

@property (nonatomic,retain) IBOutlet UITableView *orderTableView;
@property (nonatomic,retain) IBOutlet UITableViewCell *itemCell;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,retain) IBOutlet UINavigationItem *navBar;

@property (nonatomic,retain)          Order *currentOrder;
@property (nonatomic,retain)  IBOutlet UILabel *subTotalLBL,*taxLBL,*shipLBL,*statusLBL,*totalLBL;

-(IBAction)backbuttonPressed:(id)sender;
@end
