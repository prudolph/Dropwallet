//
//  RootHelpViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RootHelpViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic) int helpDetail;
@property (nonatomic,retain)IBOutlet UITableView *helpTableView;
@property(nonatomic,retain) NSDictionary *helpStrings;
@property(nonatomic,retain) NSArray *helpQsArray;
@property(nonatomic,retain) NSMutableDictionary *helpAnsDict;
@property(nonatomic,retain)NSString* headerLabelTitle;
@property (nonatomic,retain) AppDelegate *appDel;
-(CGSize)findCellHeightFromTitle:(NSString*)title andBody:(NSString*)body;

@end
