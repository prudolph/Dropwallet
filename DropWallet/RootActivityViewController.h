//
//  RootActivityViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingImage.h"
#import "AppDelegate.h"
@class OrderDetailViewController;

@interface RootActivityViewController : UITableViewController<UIGestureRecognizerDelegate,UITableViewDelegate>{
OrderDetailViewController *orderDetailViewController;

IBOutlet UITableView     *purchasesTableView;
IBOutlet UITableViewCell *orderCell;    
IBOutlet UIView* noContentView;
    UITapGestureRecognizer *tapgr;

    NSMutableArray  *purchases;
    AppDelegate *appDel;
}
@property(nonatomic,retain) UITapGestureRecognizer *tapgr;
@property (nonatomic,retain) IBOutlet OrderDetailViewController *orderDetailViewController;
@property (nonatomic,retain) IBOutlet UITableView       *purchasesTableView;
@property (nonatomic,retain) IBOutlet UITableViewCell   *orderCell;
@property(nonatomic,retain)IBOutlet UIView* noContentView;

@property (nonatomic,retain)          NSMutableArray    *purchases;
@property (nonatomic,retain)    AppDelegate *appDel;
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;
-(void)handleTapsOnScrollView:(id)sender;
-(BOOL)isScrolling;
@end
