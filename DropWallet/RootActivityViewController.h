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
#import <QuartzCore/QuartzCore.h>
@class OrderDetailViewController;

@interface RootActivityViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDelegate>{
OrderDetailViewController *orderDetailViewController;

IBOutlet UITableView     *purchasesTableView;
IBOutlet UITableViewCell *orderCell;    
IBOutlet UIView* extraStuffView;
    UITapGestureRecognizer *tapgr;

    NSMutableArray  *currentOrders;
    AppDelegate *appDel;
}
@property(nonatomic,retain) UITapGestureRecognizer *tapgr;
@property (nonatomic,retain) IBOutlet OrderDetailViewController *orderDetailViewController;
@property (nonatomic,retain) IBOutlet UITableView       *purchasesTableView;
@property (nonatomic,retain) IBOutlet UITableViewCell   *orderCell;
@property (nonatomic,retain) UIImageView *nocontentImageView,*backgroundImageview;

@property (nonatomic,retain)ScrollingImage *orderScrollImage;

@property (nonatomic,retain)          NSMutableArray    *currentOrders;
@property (nonatomic,retain)    AppDelegate *appDel;
@property(nonatomic,retain) UILabel *timestamp;
-(void)handleTapsOnScrollView:(id)sender;
-(void)reloadImages;
-(IBAction)imageWasTouched:(id)sender;
@end
