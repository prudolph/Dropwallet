//
//  EditItemViewController.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "CreditCard.h"
#import "AccountDetailViewController.h"

///Protocol
@protocol EditAddressViewControllerDelegate <NSObject>
@optional
- (void)addressSelectedFromAddressBook:(Address *)selectedAddress;
-(void)updateCurrentCreditCardAddress:(Address*)modifiedAddress;
-(void) saveNewCreditCard;
@end

@class AppDelegate;


@interface EditItemViewController : AccountDetailViewController<UIAlertViewDelegate,EditAddressViewControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>  {

    // objects that are declared in AccountDetailController:
    //appdel
    //accountOption
    
    BOOL addressSwitchBool;
    int viewPos;
    Address    *currentAddress;
    CreditCard *currentCreditCard;
    NSTimer *expDateTimer;
    IBOutlet UITableView *editItemTableView;
    
    IBOutlet UITableViewCell *addressSwitchCell,*addressCell;
    
    //Creditcard textfields
    IBOutlet UITextField *ccTypeTextField,
                         *ccFNameTextField,
                         *ccLNameTextField,
                         *ccNumTextField,
                         *ccExpMonYrTextField,
                         *ccCCV2TextField;
                        
    //address textFields
    IBOutlet UITextField *toNameTextField,
                         *address1TextField,
                         *cityTextField,
                         *stateTextField,
                         *zipTextField;
    IBOutlet UISwitch *primaryAddressSwitch;
    
    //arrays for uipicker ep date view, Creditcard info and address info
    NSArray *pickerMonths,*pickerYears,
            *CCLabels,*CCTextFields,*ccTypes,
            *addressLabels,*addressTextFields,*states;
    
   
    IBOutlet UISegmentedControl *addressSwitch;// switch for creating/choosing address
    
  
    
    //Date picker
    IBOutlet UIPickerView *expDatePicker,*cardTypePicker,*statesPicker;
    NSString *curExpMon,*curExpYear;

    //Edit creditcard ViewController
    EditItemViewController *editCCBillingAddressController;
    
   
}


@property BOOL addressSwitchBool;
@property int viewPos;
@property(nonatomic,retain)         Address *currentAddress;
@property(nonatomic,retain)         CreditCard *currentCreditCard;
@property (nonatomic,retain)IBOutlet UITableView *editItemTableView;
@property(nonatomic,retain)NSTimer *expDateTimer;
@property (nonatomic,retain)IBOutlet UITableViewCell *addressSwitchCell,
                                                      *addressCell;

//New CreditCard textFields
@property (nonatomic,retain)IBOutlet UITextField  *ccTypeTextField,
                                                    *ccFNameTextField,
                                                    *ccLNameTextField,
                                                    *ccNumTextField,
                                                    *ccExpMonYrTextField,
                                                    *ccCCV2TextField;


//Address textFields
@property (nonatomic,retain)IBOutlet UITextField *toNameTextField,
                                                *address1TextField,
                                                *cityTextField,
                                                *stateTextField,
                                                *zipTextField;
@property (nonatomic,retain)IBOutlet UISwitch *primaryAddressSwitch;
@property(nonatomic,retain) NSArray *pickerMonths,*pickerYears,*ccTypes,
                                    *CCLabels,*CCTextFields,
                                    *addressLabels,*addressTextFields,*states;


@property(nonatomic,retain) IBOutlet UIPickerView *expDatePicker,*cardTypePicker,*statesPicker;
@property (nonatomic,retain)NSString *curExpMon,*curExpYear;


@property (nonatomic,retain)IBOutlet UITextField *exp;


@property (nonatomic, unsafe_unretained) id<EditAddressViewControllerDelegate> delegate;
//BUTTON FUNCTIONS
//SaveFunctions
-(IBAction)saveCreditcard:(id)sender;
-(IBAction)saveAddress:(id)sender;
-(IBAction)saveModifiedAddressButtonPressed:(id)sender;
-(IBAction)saveNewAddressButtonPressed:(id)sender;
//address

- (IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)addressSwitched:(UISegmentedControl*)sender;
-(NSString*)validateInput:(NSString*)input
                  andType:(int)type ;
-(BOOL)zipCode:(int)code isBetween:(int)low and:(int)high;
-(BOOL)creditcardIsValidWith:(NSString*) ccType
                 andCcNumber:(NSString*)ccNumber
                     andCCV2:(NSString*)ccV2;

-(void)backButtonPressed;
@end
