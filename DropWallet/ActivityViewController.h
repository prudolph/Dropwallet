//
//  ViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    //OrderDetailViewController *orderDetailViewController;
    
    IBOutlet UITableView     *activtyTableView;
    IBOutlet UITableViewCell *orderCell;
    NSMutableArray  *purchases;
}
//@property (nonatomic,retain) IBOutlet OrderDetailViewController *orderDetailViewController;
@property (nonatomic,retain) IBOutlet UITableView       *purchasesTableView;
@property (nonatomic,retain) IBOutlet UITableViewCell   *orderCell;
@property (nonatomic,retain)          NSMutableArray    *purchases;
@end


 