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
#import "Validator.h"


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
    Validator *validator;
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
                         *address2TextField,
                         *cityTextField,
                         *stateTextField,
                         *zipTextField,
                         *addressIDTextField;   
    IBOutlet UIButton    *primaryCCButton,*primaryAddressButton,*addressSwitchButton;// switch for creating/choosing address
    
    //arrays for uipicker ep date view, Creditcard info and address info
    NSArray *pickerMonths,*pickerYears,
            *CCLabels,*CCTextFields,*ccTypes,
            *addressLabels,*addressTextFields;
    NSMutableArray *states;
   
       
  
    
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
@property(nonatomic,retain)         Validator *validator;
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
                                                *address2TextField,
                                                *cityTextField,
                                                *stateTextField,
                                                *zipTextField,
                                                *addressIDTextField;  

@property (nonatomic,retain)IBOutlet UIButton  *primaryCCButton,*primaryAddressButton,*addressSwitchButton;
@property(nonatomic,retain) NSArray *pickerMonths,*pickerYears,*ccTypes,
                                    *CCLabels,*CCTextFields,
                                    *addressLabels,*addressTextFields;

@property(nonatomic,retain)NSMutableArray *states;
@property(nonatomic,retain) IBOutlet UIPickerView *expDatePicker,*cardTypePicker,*statesPicker;
@property (nonatomic,retain)NSString *curExpMon,*curExpYear;

@property(nonatomic,retain)NSString *currentTextfieldString;
@property (nonatomic,retain)IBOutlet UITextField *exp;


@property (nonatomic, unsafe_unretained) id<EditAddressViewControllerDelegate> delegate;
//BUTTON FUNCTIONS
//SaveFunctions
-(IBAction)saveCreditcard:(id)sender;
-(void)creditCardResponse;
-(IBAction)saveAddress:(id)sender;
-(void)addressResponse;
- (IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)addressSwitched:(UITableViewRowAnimation)animation;

-(void)backButtonPressed;
-(void)primaryButtonPressed:(UIButton*)sender;
-(void)textFieldDidChange:(id)textField;
@end
