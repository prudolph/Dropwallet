//
//  OrderDetailViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Order.h"
#import "TrackingModalViewController.h"

@interface OrderDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UITableView *orderTableView;
    IBOutlet UITableViewCell *itemCell;
    Order *currentOrder;
    IBOutlet UILabel *subTotalLBL,*taxLBL,*shipLBL,*statusLBL,*totalLBL;

}

@property (nonatomic,retain) IBOutlet UITableView *orderTableView;
@property (nonatomic,retain) IBOutlet UITableViewCell *itemCell;
@property (nonatomic,retain) IBOutlet UIView *orderFooterView;
@property (nonatomic,retain)    AppDelegate *appDel;
@property (nonatomic,retain)          Order *currentOrder;
@property (nonatomic,retain)  IBOutlet UILabel *subTotalLBL,*taxLBL,*shipLBL,*statusLBL,*totalLBL;

-(IBAction)backbuttonPressed:(id)sender;
-(void)displayTrackingInfo:(id)sender;
-(void)cancelOrder;
@end
