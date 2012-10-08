//
//  AccountDetailViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingImage.h"
#import "Validator.h"
@class AppDelegate;
@class EditItemViewController;
@interface AccountDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>{

    AppDelegate *appDel;
    
    UIAlertView *editPassAlert,*confirmDelete;
    NSMutableDictionary*cclogos;
    //TableView
    IBOutlet UITableView *accountDetailTableView;

    
    //view specifc arrays
    NSArray *currentArray,
            *passwordLabelArray,
            *passwordTextFieldArray,
            *personalLabelArray,
            *personalTextfieldArray;
    
    //Table cells
    IBOutlet UITableViewCell *ccTableViewCell,
                             *addressTableViewCell,
                             *editTableViewCell;

 

    IBOutlet UITextField *currentPass,*nPass,*nPass2,*userFName,*userLName,*userEmail;

    int accountOption;
   
    
    IBOutlet EditItemViewController *editItemViewController;
    
}


@property (nonatomic,retain)NSArray *currentArray,
                                    *passwordLabelArray,
                                    *passwordTextFieldArray,
                                    *personalLabelArray,
                                    *personalTextfieldArray;

@property (nonatomic,retain) UIAlertView *editPassAlert,*confirmDelete;

@property (nonatomic,retain) NSMutableDictionary *cclogos;
@property (nonatomic,retain) IBOutlet UITableViewCell *ccTableViewCell,
                                                      *addressTableViewCell,
                                                      *editTableViewCell;

@property (nonatomic,retain) IBOutlet UITableView *accountDetailTableView;

@property(nonatomic,retain)    NSString* currentTextString;
@property (nonatomic,retain)IBOutlet UITextField *currentPass,
                                                 *nPass,
                                                 *nPass2,
                                                 *userFName,
                                                 *userLName,
                                                 *userEmail;
@property (nonatomic,retain) AppDelegate *appDel;
@property (nonatomic) int accountOption,rowforDeletion;


@property (nonatomic,retain) IBOutlet EditItemViewController *editItemViewController;

-(IBAction)newItem:(id)sender;
-(IBAction)savePersonalInfo:(id)sender;
-(IBAction)updatePass:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
