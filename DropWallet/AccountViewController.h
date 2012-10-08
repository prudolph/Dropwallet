//
//  AccountViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UINavigationController<UITableViewDelegate,UITableViewDataSource>{
    
     IBOutlet UITableView *accountSettingsTable;
    
}

@property (nonatomic,retain) IBOutlet UITableView *accountSettingsTable;
@end
