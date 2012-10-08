//
//  EditItemViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define EDITCC 4
#define EDITADDRESS 5
#define NEWADDRESS 6
#define NEWCC 7
#define EDITCCADDRESS 8 
#define NEWCCADDRESS 9


//Define cc Label Tags
#define CCNUMTAG 0
#define CCTYPETAG 1
#define CCFNAMETAG 2
#define CCLNAMETAG 3
#define CCEXPMOYRTAG 4
#define CCCCV2TAG 5
#define CCPRITAG 6

//define Address Lable tags
#define ADD_TONAMETAG 7
#define ADD_ADDRESS1TAG 8
#define ADD_ADDRESS2TAG 9
#define ADD_CITYTAG 10
#define ADD_STATETAG 11
#define ADD_ZIPTAG 12
#define ADD_PRITAG 13




CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 1.2;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;



#import "EditItemViewController.h"
#import "AddressPickerViewController.h"
#import "AppDelegate.h"
@implementation EditItemViewController

//Boolean for choosing or creating new address
@synthesize addressSwitchBool;
@synthesize viewPos;
//Objects dedicated to the view
@synthesize currentAddress,currentCreditCard;
@synthesize validator;
//TableView
@synthesize editItemTableView;

//TableViewCell
@synthesize  addressSwitchCell,addressCell;
@synthesize expDateTimer;
//Creditcard Text fields
@synthesize ccTypeTextField,
            ccFNameTextField,
            ccLNameTextField,
            ccNumTextField,
            ccExpMonYrTextField,
            ccCCV2TextField;

//primary address buttons
@synthesize primaryCCButton,primaryAddressButton,addressSwitchButton;
//Address textFields
@synthesize toNameTextField,
            address1TextField,
            address2TextField,
            cityTextField,
            stateTextField,
            zipTextField,
            addressIDTextField;  

//Arrays
@synthesize pickerMonths,pickerYears,
            CCLabels,CCTextFields,ccTypes,
            addressLabels,addressTextFields,states;

@synthesize expDatePicker,cardTypePicker,statesPicker;
@synthesize curExpMon,curExpYear;
@synthesize currentTextfieldString;
@synthesize exp;

@synthesize delegate;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        validator=[[Validator alloc]init];
        curExpMon=@"01";
        curExpYear=@"2012";
        currentCreditCard = [[CreditCard alloc]init];
        currentAddress = [[Address alloc]init];
           }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

     // set up Address Switch
    addressSwitchButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 129, 24)];
    [addressSwitchButton addTarget:self action:@selector(addressSwitched:) forControlEvents:UIControlEventTouchUpInside];
    [addressSwitchButton setImage:[UIImage imageNamed:@"ButtonUncheckedAddNewAddress.png"] forState:UIControlStateNormal];
    addressSwitchBool=YES;
    
    //load states into the picker
    NSString *statesPath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
    NSDictionary* statesArray = [[NSDictionary alloc]initWithContentsOfFile:statesPath];


    states=[[NSMutableArray alloc] initWithArray:[statesArray allValues] ];
    for(int i=0;i<[states count];i++){
        [states replaceObjectAtIndex:i withObject:[[states objectAtIndex:i]substringToIndex:2]];
        
    }

    states=[states sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];


    
    //Setup for the picker view
    pickerMonths = [[NSArray alloc] initWithObjects:@"01",@"02",@"03",
                                                    @"04",@"05",@"06",
                                                    @"07",@"08",@"09",
                                                    @"10",@"11",@"12", nil];
    
    pickerYears  =[[NSArray alloc] initWithObjects:@"2012",@"2013",
                                                   @"2014",@"2015",
                                                   @"2016",@"2017",
                                                   @"2018",@"2019",
                                                   @"2020",@"2021",
                                                   @"2022",@"2024", nil];
    ccTypes = [[NSArray alloc]initWithObjects:@"American Express",@"Discover",@"MasterCard",@"Visa", nil];
    expDatePicker= [[UIPickerView alloc] init];
    expDatePicker.delegate= self;
    expDatePicker.showsSelectionIndicator=YES;
    
    cardTypePicker = [[UIPickerView alloc]init];
    cardTypePicker.delegate=self;
    cardTypePicker.showsSelectionIndicator=YES;
    
    statesPicker = [[UIPickerView alloc]init];
    statesPicker.delegate=self;
    statesPicker.showsSelectionIndicator=YES;
   
    // CCLables and TextFields
    CCLabels = [[NSArray alloc] initWithObjects:[appDel.appText objectForKey:@"CCLabel-CC#_Lbl"],
                                                [appDel.appText objectForKey:@"CCLabel-Fname_Lbl"],
                                                [appDel.appText objectForKey:@"CCLabel-Lname_Lbl"],
                                                [appDel.appText objectForKey:@"CCLabel-Exp_Lbl"],
                                                [appDel.appText objectForKey:@"CCLabel-cvv2_Lbl"],
                                                [appDel.appText objectForKey:@"CCLabel-Prim_Lbl"],nil];    
   
        ccTypeTextField   = [[UITextField alloc] init];
        ccFNameTextField  = [[UITextField alloc] init];
        ccLNameTextField  = [[UITextField alloc] init];
        ccNumTextField    = [[UITextField alloc] init];
        ccExpMonYrTextField = [[UITextField alloc] init];
        ccExpMonYrTextField.inputView=expDatePicker;
        ccCCV2TextField   = [[UITextField alloc] init];
      
   
    
    primaryCCButton =[[UIButton alloc ]initWithFrame:CGRectMake(200, 8, 31, 31)];
    [primaryCCButton addTarget:self action:@selector(primaryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [primaryCCButton setImage:[UIImage imageNamed:@"CheckedBox.png"] forState:UIControlStateSelected];
    [primaryCCButton setImage:[UIImage imageNamed:@"UncheckedBox.png"] forState:UIControlStateNormal];
    
    //set tags for each text field
    ccNumTextField.tag      =CCNUMTAG;
    ccTypeTextField.tag     =CCTYPETAG;
    ccFNameTextField.tag    =CCFNAMETAG;
    ccLNameTextField.tag    =CCLNAMETAG;
    ccExpMonYrTextField.tag =CCEXPMOYRTAG;
    ccCCV2TextField.tag     =CCCCV2TAG;
    primaryCCButton.tag     =CCPRITAG; 
  
    //add all the text fields to an array
    CCTextFields =[[NSArray alloc] initWithObjects:ccNumTextField,
                   ccFNameTextField,
                   ccLNameTextField,
                   ccExpMonYrTextField,
                   ccCCV2TextField,
                   primaryCCButton, nil];

 
       
   ////
    
    //Address Labels and TextFields
        addressLabels = [[NSArray alloc] initWithObjects:[appDel.appText objectForKey:@"Add_Label-ToName_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-Add1_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-Add2_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-City_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-State_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-Zip_Lbl"],
                                                         [appDel.appText objectForKey:@"Add_Label-Pri_Lbl"],
                                                         nil]; 
                                            
        toNameTextField   = [[UITextField alloc] init];
        address1TextField = [[UITextField alloc] init];
        address2TextField = [[UITextField alloc] init];
        cityTextField     = [[UITextField alloc] init];
        stateTextField    = [[UITextField alloc] init];
        zipTextField      = [[UITextField alloc] init];
        addressIDTextField = [[UITextField alloc] init];

    primaryAddressButton =[[UIButton alloc ]initWithFrame:CGRectMake(190, 8, 71, 26)];
    [primaryAddressButton addTarget:self action:@selector(primaryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [primaryAddressButton setImage:[UIImage imageNamed:@"PrimaryShipAddressCheckbox.png"] forState:UIControlStateSelected];
     [primaryAddressButton setImage:[UIImage imageNamed:@"PrimaryShipAddressUnchecked.png"] forState:UIControlStateNormal];
    
    //Set Tags
    toNameTextField.tag    =ADD_TONAMETAG;  
    address1TextField.tag  =ADD_ADDRESS1TAG;
    address2TextField.tag  =ADD_ADDRESS2TAG;
    cityTextField.tag      =ADD_CITYTAG;  
    stateTextField.tag     =ADD_STATETAG; 
    zipTextField.tag       =ADD_ZIPTAG; 
    addressIDTextField.tag =ADD_PRITAG;
    
    addressTextFields = [[NSArray alloc]initWithObjects:
                         toNameTextField,
                         address1TextField,
                         address2TextField,                                        
                         cityTextField,
                         stateTextField,
                         zipTextField,nil];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void)viewWillAppear:(BOOL)animated{
       self.view = editItemTableView;

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
    saveButton.title=@"Back"; 
    [saveButton setTintColor:[UIColor colorWithWhite:.55 alpha:1]];
     

    

    
    // Switch handles which view to display in the controller;
    switch (self.accountOption) {
            
    //Edit Creditcard View
        case EDITCC:{
            
            self.navigationItem.title =[appDel.appText objectForKey:@"Account_View-Title"];          
            curExpMon=currentCreditCard.expMonth;
            curExpYear=currentCreditCard.expYear;

            //Load all the credit card info
            //Since were editing a creditcard load the current credit card info into all the text fields
            ccTypeTextField.text=   currentCreditCard.ccType;
            ccFNameTextField.text=  currentCreditCard.cardFirstName;
            ccLNameTextField.text=  currentCreditCard.cardLastName;
            ccNumTextField.text=    currentCreditCard.cardNumber;
            ccExpMonYrTextField.text= [NSString stringWithFormat:@"%@/%@",currentCreditCard.expMonth,currentCreditCard.expYear];
            ccCCV2TextField.text=   currentCreditCard.cvv2;
            
            //disable proper cells          
            for (int i=0;i<[CCTextFields count];i++){
                if (!([((UITextField*)[CCTextFields objectAtIndex:i])isEqual:ccExpMonYrTextField]||
                      [((UITextField*)[CCTextFields objectAtIndex:i])isEqual:ccCCV2TextField]    ||
                      [((UIButton*)   [CCTextFields objectAtIndex:i])isEqual:primaryCCButton]  )) {
                    [((UITextField*)[CCTextFields objectAtIndex:i])setEnabled:NO];
                }
            }
       
               
            //Load the address info
            // set the credit card billing information to the text fields.
         
             toNameTextField.text =  currentCreditCard.billingAddress.toName;
            address1TextField.text= currentCreditCard.billingAddress.address1;                   
            address2TextField.text= currentCreditCard.billingAddress.address2;
            cityTextField.text =    currentCreditCard.billingAddress.city;
            stateTextField.text =   currentCreditCard.billingAddress.state;
            zipTextField.text =     currentCreditCard.billingAddress.zip;
            
           
            if(currentCreditCard.isPrimary )
                [primaryCCButton setSelected:YES];
            else
                [primaryCCButton setSelected:NO];
        
            
            

            //add the Save Button to the view  
            [saveButton setAction:@selector(saveCreditcard:)];
            self.navigationItem.rightBarButtonItem = saveButton;
            break;
        }
            
        
        case NEWCC:{
            self.navigationItem.title =  [appDel.appText objectForKey:@"New_CC_View-Title"];           
             //Save Button  
            [saveButton setAction:@selector(saveCreditcard:)];
            self.navigationItem.rightBarButtonItem = saveButton;
        
           
                
            break;
        }

            //Edit Address View      
        case EDITADDRESS:{
       
             self.navigationItem.title =[appDel.appText objectForKey:@"Account_View-Title"];   
           
            // Load the current address information into the text fields
            toNameTextField.text =  currentAddress.toName;
            address1TextField.text= currentAddress.address1;
            address2TextField.text= currentAddress.address2 ;
            cityTextField.text =    currentAddress.city;
            stateTextField.text =   currentAddress.state;
            zipTextField.text =     currentAddress.zip;

            if(currentAddress.primary )
                [primaryAddressButton setSelected:YES];
            else
                [primaryAddressButton setSelected:NO];
            
           // add the save button
            [saveButton setAction:@selector(saveAddress:)];
                      self.navigationItem.rightBarButtonItem = saveButton;
            break;
        }
            
        case NEWADDRESS:
             addressSwitchBool=YES;
            self.navigationItem.title =  [appDel.appText objectForKey:@"New_ADD_View-Title"];
            [saveButton setAction:@selector(saveAddress:)];
            self.navigationItem.rightBarButtonItem = saveButton;
            break;  
            
       
        case EDITCCADDRESS:
                     self.navigationItem.title =[appDel.appText objectForKey:@"Account_View-Title"];   
            [saveButton setAction:@selector(saveAddress:)];
             self.navigationItem.rightBarButtonItem = saveButton;
            
            //Load the address info
            // set the credit card billing information to the text fields.
            toNameTextField.text =  currentAddress.toName;
            address1TextField.text= currentAddress.address1;                   
            address2TextField.text= currentAddress.address2;
            cityTextField.text =   currentAddress.city;
            stateTextField.text =   currentAddress.state;
            zipTextField.text =    currentAddress.zip;
           
            break;
            

        default:
            break;
    }

}
-(void)viewDidAppear:(BOOL)animated{

    
    /*
     currentAddress.toName   ==NULL && 
     currentAddress.address1 ==NULL &&
     currentAddress.city     ==NULL &&
     currentAddress.state    ==NULL && 
     currentAddress.zip       ==NULL &&
     */
    
     if(currentAddress.addressID ==NULL &&
       accountOption == EDITCCADDRESS){
        [self addressSwitched:UITableViewRowAnimationFade];   
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
       return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(accountOption== EDITCC|| accountOption == NEWCC ||accountOption == EDITCCADDRESS){
        return 2;//Credit Card Section, Segmented Control Section,AddressSection
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(accountOption== EDITCC || accountOption == NEWCC){
        if(section ==0)
            return [CCLabels count];
        if(section ==1)
            return 1;
            }
    
    else if(accountOption == EDITADDRESS||accountOption == NEWADDRESS )
        return [addressTextFields count]-1;
    
    else if(accountOption==EDITCCADDRESS && section==0 ){
        if(addressSwitchBool)
            return [addressTextFields count]-1;
        else {
              return 1;
        }
    }
    
    else if(accountOption ==EDITCCADDRESS && (section==1||!addressSwitchBool))
        return [appDel.addressBook count];
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //if user is selecting an existing address make a bigger cell
     
    if([indexPath section]==1 && currentCreditCard.billingAddress ==nil && accountOption==NEWCC){
         return 44.0;
    }
    if([indexPath section]==1 ) return 76.0;
    else return 44.0;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(accountOption==EDITCCADDRESS && section==1 && addressSwitchBool) {
        UIView *addNewAddressView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
                addressSwitchButton.frame = CGRectMake(20.0, 10.0, 129, 24);
        [addNewAddressView addSubview:addressSwitchButton];
        
        return addNewAddressView;
    }
   
    else if(section==0){
    UILabel *headerLabel=[[UILabel alloc]init];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
    [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
    headerLabel.frame=CGRectMake(60, 7.0, 200, 40);
    
    if (accountOption==EDITCC)
        [headerLabel setText:@"EDIT CREDIT CARD"];
    else if (accountOption==NEWCC)
            [headerLabel setText:@"ADD CREDIT CARD"];
      else if (accountOption==EDITADDRESS)
            [headerLabel setText:@"EDIT ADDRESS"]; 
      else if (accountOption==NEWADDRESS)
          [headerLabel setText:@"ADD ADDRESS"];
      else if(accountOption == EDITCCADDRESS){
          [headerLabel setText:@"SELECT AN ADDRESS"];
         [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17.0]];
      }
    
    UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
          headerView.frame=CGRectMake(0, 0, 320.00, 34.0);
    [headerView addSubview:headerLabel ];
    
      return headerView;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(accountOption==EDITCCADDRESS && section==1 && addressSwitchBool)
        return 40.0;
    else if(section==0)
        return  40.0;
    else return 0.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell ;
    NSUInteger row = [indexPath row];
    
    
     
    // If the user is choosing from an exisitng address; load address cells in 
    // bottom section.
    
  if(((accountOption== EDITCC|| accountOption == NEWCC) && [indexPath section]==1) || (accountOption == EDITCCADDRESS && [indexPath section] ==1)){
       //check if card has primary Address
     
      CellIdentifier=@"AddressCellIdentifier";
      cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
      
      
      
      UILabel *primaryLabel =       (UILabel *)[cell viewWithTag:5];
      UILabel *nameLabel =          (UILabel *)[cell viewWithTag:10];
      UILabel *addressLabel =       (UILabel *)[cell viewWithTag:20];
      UILabel *cityStateZipLabel =  (UILabel *)[cell viewWithTag:30];
      
      if(currentCreditCard.billingAddress.toName   !=NULL && 
                      currentCreditCard.billingAddress.address1 !=NULL &&
                      currentCreditCard.billingAddress.city     !=NULL &&
                      currentCreditCard.billingAddress.state    !=NULL && 
                      currentCreditCard.billingAddress.zip      !=NULL && (accountOption==EDITCC ||accountOption==NEWCC)){
                  
                  primaryLabel.hidden = YES;
                  nameLabel.text =            [NSString stringWithFormat:@"%@", currentCreditCard.billingAddress.toName];
                  addressLabel.text =         [NSString stringWithFormat:@"%@", currentCreditCard.billingAddress.address1 ];
                  cityStateZipLabel.text =    [NSString stringWithFormat:@"%@, %@ %@", currentCreditCard.billingAddress.city,
                                              currentCreditCard.billingAddress.state,
                                               currentCreditCard.billingAddress.zip];

                  
              }
      
      else {
             
          int billingIndex=-1;
                  if((accountOption== EDITCC|| accountOption == NEWCC))
                      for(Address * a in appDel.addressBook){
                          if ([currentCreditCard.billingAddress addressIsEqualto:a]) {
                              billingIndex = [appDel.addressBook indexOfObject:a]; 
                              currentAddress = a;
                              break;
                          }
                      }
                    else if(accountOption==EDITCCADDRESS)
                        billingIndex=[indexPath row];
             
                    else {
                        billingIndex=-1;
                    }
                  
              if(billingIndex>=0){
                    
                    primaryLabel.hidden = YES;
                    nameLabel.text =            [NSString stringWithFormat:@"%@", ((Address*)[appDel.addressBook objectAtIndex:billingIndex]).toName];
                    addressLabel.text =         [NSString stringWithFormat:@"%@", ((Address*)[appDel.addressBook objectAtIndex:billingIndex]).address1 ];
                    cityStateZipLabel.text =    [NSString stringWithFormat:@"%@, %@ %@", ((Address*)[appDel.addressBook objectAtIndex:billingIndex]).city,
                                                                                        ((Address*)[appDel.addressBook objectAtIndex:billingIndex]).state,
                                                                                        ((Address*)[appDel.addressBook objectAtIndex:billingIndex]).zip];
                  
                }
              
              
              else {
                 
                  primaryLabel.hidden = YES;
                  nameLabel.text=@"Select an address";
                  nameLabel.frame=CGRectMake(18, 10, 180, 21);
                  addressLabel.hidden = YES;
                  cityStateZipLabel.hidden =YES;
                  ((UIImageView*) [[[cell contentView]subviews]objectAtIndex:0]).frame=CGRectMake(0, 0, 300, 44);
                  UIImageView * disclosureView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Disclosure.png"]];
                  disclosureView.frame=CGRectMake(280, 12, 16, 18);
                  [cell addSubview:disclosureView ];          
                  
              }
      }

      if(accountOption!=EDITCCADDRESS){
        
      }
      else {
          if([currentAddress addressIsEqualto:[appDel.addressBook objectAtIndex:[indexPath row]]]){
              UIImageView *checkedBox = ((UIImageView*)[cell viewWithTag:75]);
              checkedBox.hidden=NO;
          }
      }
    
        
      return cell;
        }

    //Load a normal editcell
    else{
    
            cell = [tableView dequeueReusableCellWithIdentifier:@"editCell"];               
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditCell" 
                                                         owner:self options:nil];
                if ([nib count] > 0) 
                    cell = self.editTableViewCell;
               
                else 
                NSLog(@"failed to load MessageCell nib!");
           
            UILabel *editCellLabel = (UILabel *)[cell viewWithTag:40];
            UITextField *editTextField = (UITextField*)[cell viewWithTag:50];
            editTextField.background=[UIImage imageNamed:@"FieldBackground.png"];
       
   
        // modify the new cell
        if(accountOption== EDITCC|| accountOption == NEWCC){
            
            //if the view is loading the cc section
            if([indexPath section]==0){

         
                //set the textfields tag and text   
                if([[CCTextFields objectAtIndex:row] isKindOfClass:[UIButton class]]){
                    editTextField.hidden=YES;
                    [cell addSubview:primaryCCButton];
                    editCellLabel.text = [CCLabels objectAtIndex:row];
                }

                else{

                [editTextField setTag:((UITextField*)[CCTextFields objectAtIndex:row]).tag];
                [editTextField setText:((UITextField*)[CCTextFields objectAtIndex:row]).text];
                
                if(editTextField.tag==CCEXPMOYRTAG){
                    editTextField.inputView=expDatePicker;
                    [editTextField setDelegate:self];
                    [editTextField setText:ccExpMonYrTextField.text];
                     ccExpMonYrTextField=editTextField;
                     
                    }
                
                if(editTextField.tag==CCTYPETAG){ 
    
                    editTextField.inputView=cardTypePicker;
                    [editTextField setDelegate:self];                      
                    editTextField.text=ccTypeTextField.text;
                    editTextField.background=[UIImage imageNamed:@"DropdownFieldBoxes.png"];
                    ccTypeTextField=editTextField;

                }
                
                if(editTextField.tag==CCNUMTAG){
                    editTextField.frame=CGRectMake(108, 6, 145, 31);
                    [editTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    [editTextField setDelegate:self];
                    [editTextField setText:ccNumTextField.text];
                    if (accountOption==EDITCC) {//hide the cc number
                        //bullet (U+2022)
                        [((UIImageView*)[cell viewWithTag:80]) setHidden:NO];
                                          [self textFieldDidChange:currentCreditCard.ccType];
                        int len=[ccNumTextField.text length];
                        NSString* bullet=[NSString stringWithUTF8String:"\u2022"];
                        NSString *hiddenCC = [NSString stringWithFormat:@""];
                        for(int i =0;i<len-4;i++){
                            hiddenCC=[hiddenCC stringByAppendingFormat:bullet];
                        }
                        hiddenCC=[hiddenCC stringByAppendingFormat:[ccNumTextField.text substringFromIndex:(len-4)]];
                        [editTextField setText:hiddenCC];
                     }
                    ccNumTextField=editTextField;
                }
                if(editTextField.tag==CCCCV2TAG){
                       [editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    if([ccCCV2TextField.text length]==0 && accountOption!=NEWCC)
                      editTextField.text=@"3-4 digits";
                        }
                
                
                
                //set the labels text  
                editCellLabel.text = [CCLabels objectAtIndex:row];
                //set if its editable
                [editTextField setEnabled:[((UITextField*)[CCTextFields objectAtIndex:row])isEnabled ]];
                if(![editTextField isEnabled]){
                    [editTextField setTextColor:[UIColor grayColor]];
                }
            
            }
            }
            else if([indexPath section]==2){    //addresses
                editCellLabel.text = [addressLabels objectAtIndex:row];
                [editTextField setTag:((UITextField*)[addressTextFields objectAtIndex:row]).tag];
                [editTextField setText:((UITextField*)[addressTextFields objectAtIndex:row]).text];
                [editTextField setEnabled:[((UITextField*)[addressTextFields objectAtIndex:row])isEnabled ]];
                
                if(editTextField.tag == ADD_ZIPTAG)
                    [editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];

                if(editTextField.tag == ADD_STATETAG){
                    editTextField.inputView = statesPicker;
                   [editTextField setDelegate:self];
                    [editTextField setText:stateTextField.text];
                    editTextField.background=[UIImage imageNamed:@"DropdownFieldBoxes.png"];
                    stateTextField = editTextField;
                }
                                   
                 
            } 
            
        }
                
        
    
    else if(accountOption ==EDITADDRESS|| accountOption ==NEWADDRESS ||(accountOption == EDITCCADDRESS && [indexPath section]==0)){
        
        if(!addressSwitchBool){
            editTextField.hidden=YES;
            editCellLabel.hidden=YES;
            
            UIImageView *addressButtonImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ButtonUncheckedAddNewAddress.png"]];
            addressButtonImage.frame=CGRectMake(20.0, 10.0, 129, 24);
            [cell addSubview:addressButtonImage];
             [cell setSelectionStyle:UITableViewCellEditingStyleNone];
          
                      return cell;
            
        }
         
        
        editTextField.frame=CGRectMake(11, 6, 279, 30);
        editCellLabel.hidden=YES;
        
        if([[addressTextFields objectAtIndex:row] isKindOfClass:[UIButton class]]){
            editTextField.hidden=YES;
            [cell addSubview:primaryAddressButton];
            editCellLabel.text = [addressLabels objectAtIndex:row];
        }
        
        else{
            [editTextField setPlaceholder:[addressLabels objectAtIndex:row]];
            [editTextField setTag:((UITextField*)[addressTextFields objectAtIndex:row]).tag];
            [editTextField setText:((UITextField*)[addressTextFields objectAtIndex:row]).text];
            [editTextField setEnabled:[((UITextField*)[addressTextFields objectAtIndex:row])isEnabled ]];
            
            if(row==3){//city & state rows
                editTextField.frame = CGRectMake(11, 6, 130.0, 30);
                UITextField *editTextField1 = [cell viewWithTag:60];
                editTextField1.frame=CGRectMake(150, 6, 140, 30);
                editTextField1.hidden=NO;
                [editTextField1 setPlaceholder:[addressLabels objectAtIndex:row+1]];
                [editTextField1 setTag:((UITextField*)[addressTextFields objectAtIndex:row+1]).tag];
                [editTextField1 setText:((UITextField*)[addressTextFields objectAtIndex:row+1]).text];
                [editTextField1 setEnabled:[((UITextField*)[addressTextFields objectAtIndex:row+1])isEnabled]];
                editTextField1.background = [UIImage imageNamed:@"DropdownFieldBoxes.png"];
                //set the state picker to edittextfield1
                editTextField1.inputView = statesPicker;
                [editTextField1 setDelegate:self];
                [editTextField1 setText:stateTextField.text];
                stateTextField = editTextField1;

                
            }

            if(row==4){   
                editTextField.frame = CGRectMake(11, 6, 130.0, 30);
                [editTextField setPlaceholder:[addressLabels objectAtIndex:row+1]];
                [editTextField setPlaceholder:[addressLabels objectAtIndex:row+1]];
                [editTextField setTag:((UITextField*)[addressTextFields objectAtIndex:row+1]).tag];
                [editTextField setText:((UITextField*)[addressTextFields objectAtIndex:row+1]).text];
                [editTextField setEnabled:[((UITextField*)[addressTextFields objectAtIndex:row+1])isEnabled ]];
                [editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                
                //add primary button 
                  primaryAddressButton.frame=CGRectMake(190.0, 4.0, 74.0, 36.0);
                if(accountOption!=EDITCCADDRESS)
                [cell addSubview:primaryAddressButton];
            }
         
        }
    [cell setEditingAccessoryType:UITableViewCellEditingStyleNone];
}
    
} 
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath section]==0 &&!addressSwitchBool && accountOption==EDITCCADDRESS){
        [self addressSwitched:nil];
    }
// if the user is selecting from the address book and row selected is in section 2 then set new address
   else if([indexPath section]==1&&
      ((accountOption==EDITCC) ||(accountOption==NEWCC))){
       [self.view endEditing:YES];

       EditItemViewController *editBillingAddressView = [[EditItemViewController alloc]init];

        editBillingAddressView.accountOption=EDITCCADDRESS;
        
        //set address information to the textfields
        editBillingAddressView.toNameTextField.text=       ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).toName;
        editBillingAddressView.addressIDTextField.text=    ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).addressID;
        editBillingAddressView.address1TextField.text=     ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).address1;
        editBillingAddressView.cityTextField.text=         ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).city;
        editBillingAddressView.stateTextField.text=        ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).state;
        editBillingAddressView.zipTextField.text=          ((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).zip;
        editBillingAddressView.currentAddress=self.currentCreditCard.billingAddress;
       UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
      [ newBackButton setTintColor:[UIColor darkGrayColor]];
       [[self navigationItem] setBackBarButtonItem: newBackButton];
       
        [self.navigationController pushViewController:editBillingAddressView animated:YES];
   }

       else if(accountOption==EDITCCADDRESS && [indexPath section]==1){
            //clear all other check marks and check of the selected row;

                                  UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            for(int i = 0; i < [tableView numberOfRowsInSection:1]; i++){
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[[indexPath indexPathByRemovingLastIndex]indexPathByAddingIndex: i]];
                (( UIImageView*) [cell viewWithTag:75]).hidden=YES;
            }
           [[cell viewWithTag:75] setHidden:NO];
           currentAddress=[appDel.addressBook objectAtIndex:[indexPath row] ];
         
           
           
           // set the credit card billing information to the text fields.
           toNameTextField.text =  currentAddress.toName;
           address1TextField.text= currentAddress.address1;                   
           address2TextField.text= currentAddress.address2;
           cityTextField.text =    currentAddress.city;
           stateTextField.text =   currentAddress.state;
           zipTextField.text =     currentAddress.zip;
           [editItemTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

        }   
   
 
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO ;
}


#pragma Mark - BUTTON FUNCTIONS




-(IBAction)saveCreditcard:(id)sender{
   [self.view endEditing:YES];
    [self textFieldDoneEditing:nil];
    [self.view addSubview:appDel.loadIndicator];
    [appDel.loadIndicator startAnimating];
    
   // currentCreditCard.billingAddress=currentAddress;
    NSString *vError=[NSString stringWithFormat:@""];
    CreditCard *updatedCreditCard = 
                        [[CreditCard alloc ]initWithCCtype: ccTypeTextField.text
                                             cardfirstName: ccFNameTextField.text 
                                              cardlastName: ccLNameTextField.text 
                                                    toName: currentCreditCard.billingAddress.toName
                                                cardNumber: ccNumTextField.text 
                                                  expMonth: curExpMon
                                                   expYear: curExpYear
                                                      cvv2: ccCCV2TextField.text 
                                                toAddress1: currentCreditCard.billingAddress.address1
                                                toAddress2: currentCreditCard.billingAddress.address2
                                                      city: currentCreditCard.billingAddress.city
                                                     state:  currentCreditCard.billingAddress.state
                                                       zip:  currentCreditCard.billingAddress.zip
                                              billingAddID:  currentCreditCard.billingAddress.addressID
                                                 paymentID: (currentCreditCard.paymentID ==NULL)? NULL:currentCreditCard.paymentID
                                             primaryMethod:(primaryCCButton.isSelected)?YES:NO];
    
    NSLog(@"Current Add %@",currentAddress);
    NSLog(@"Updated CC %@", updatedCreditCard);
    
       if(accountOption ==  EDITCC)
        vError=[validator validateCCForUpdate:updatedCreditCard];
    else
        vError=[validator validate:updatedCreditCard];
    
    
    if([vError length]>0){
         [appDel.loadIndicator stopAnimating];
        [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"Edit_CC_Fail-Title"] andMsg:vError];
        vError=@"";
    }
    else{

    NSLog(@"New credit card %@",updatedCreditCard);
    
        if (accountOption == EDITCC)
            [appDel updateModifiedCreditCardToServer:updatedCreditCard];
            
        else if(accountOption == NEWCC)
        [appDel UpdateNewCreditCardToServer:updatedCreditCard];
            
    }
}
-(void)creditCardResponse{
   
    [appDel.loadIndicator stopAnimating];
    [editItemTableView reloadData];        
    [accountDetailTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    

    [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"Edit_CC_Success-Title"] 
                                    andMsg:[appDel.appText objectForKey:@"Edit_CC_Success-Msg"]];
                     
    [appDel loadAddressBook];
    }

-(IBAction)saveAddress:(id)sender{
    [self.view endEditing:YES];

    NSString *vError=[NSString stringWithFormat:@""];


    Address *updatedAddress=[[Address alloc]
                             initWithName:toNameTextField.text 
                             address1:address1TextField.text 
                             address2:address2TextField.text 
                             city:cityTextField.text 
                             state:stateTextField.text 
                             zip:zipTextField.text 
                             primary:(primaryAddressButton.isSelected)?YES:NO 
                             withID:(currentAddress.addressID ==NULL)? NULL:currentAddress.addressID];

    vError=[validator validate:updatedAddress];
     
    if([vError length]>0){
        [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"Edit_Add_Fail-Title"] andMsg:vError];
        vError=@"";
    }
   
    else if(accountOption==EDITCCADDRESS || accountOption==EDITCC){
        ((EditItemViewController*)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]).currentCreditCard.billingAddress=updatedAddress;
        [((EditItemViewController*)[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]).editItemTableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    NSLog(@"New Address %@",updatedAddress);
        [self.view addSubview:appDel.loadIndicator ];
        [appDel.loadIndicator startAnimating];
    
        if (accountOption == EDITADDRESS) 
            [appDel updateModifiedAddressToServer:updatedAddress];
        else if(accountOption == NEWADDRESS)
            [appDel updateNewAddressToServer:updatedAddress];
                          
    }
}

-(void)addressResponse{

       [appDel.loadIndicator stopAnimating];
        [editItemTableView reloadData];        
        [self.navigationController popViewControllerAnimated:YES];
        [appDel displayErrorMsgToUserWithTitle:[appDel.appText objectForKey:@"Edit_Add_Success-Title"] 
                                        andMsg:[appDel.appText objectForKey:@"Edit_Add_Success-Msg"]];
      
}

-(IBAction)addressSwitched:(UITableViewRowAnimation)animation{
   
    if (addressSwitchBool){
        addressSwitchBool=NO;
      [addressSwitchButton setImage:[UIImage imageNamed:@"ButtonUncheckedAddNewAddress.png"] forState:UIControlStateNormal];
    }
    else{
        addressSwitchBool=YES;addressIDTextField.text=NULL;
        [addressSwitchButton setImage:[UIImage imageNamed:@"ButtonAddNewAddress.png"] forState:UIControlStateNormal];
        }
    [editItemTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:animation];
   
    
}

#pragma mark - picker funcs

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual:cardTypePicker]||[pickerView isEqual:statesPicker])
        return 1;
    else      
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:cardTypePicker])
        return [ccTypes count];
  
    if([pickerView isEqual:statesPicker])
        return [states count];
        
    if (component==0) 
            return [pickerMonths count];
    else 
            return [pickerYears count];
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {   

    if([thePickerView isEqual:cardTypePicker]){
        return [ccTypes objectAtIndex:row];
    }
    if([thePickerView isEqual:statesPicker]){
        return [NSString stringWithFormat:@"                       %@",[states objectAtIndex:row]];
    }
    if (component==0) {
        return [pickerMonths objectAtIndex:row];
    }
    else 
        return [pickerYears objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{    
    expDateTimer = [NSTimer scheduledTimerWithTimeInterval:1.45 target:self selector:@selector(textFieldDoneEditing:) userInfo:nil repeats:NO];
 
    if([pickerView isEqual:cardTypePicker]) {
        ccTypeTextField.text=[ccTypes objectAtIndex:row];
        if([ccTypeTextField.text isEqualToString:@"Other"]){
            ccTypeTextField.text=@""; 
            [ccTypeTextField resignFirstResponder];
            ccTypeTextField.inputView=NULL;
            [ccTypeTextField setKeyboardType:UIKeyboardTypeDefault];
            [ccTypeTextField becomeFirstResponder];
            [expDateTimer invalidate];
        }
        else{
         [ccTypeTextField resignFirstResponder];
        [expDateTimer invalidate];
        }
            
    }
    else if([pickerView isEqual:statesPicker])   {
        stateTextField.text=[states objectAtIndex:row];
    } 
       else{
           if (component==0) {
               curExpMon=[pickerMonths objectAtIndex:row];
               if([curExpYear isEqual:@""])
                   curExpYear=[pickerYears objectAtIndex:row];

           }
           else if(component==1){
               curExpYear=[pickerYears objectAtIndex:row];
               if([curExpMon isEqual:NULL])
                   curExpMon=[pickerMonths objectAtIndex:row];

           }
   
           [ccExpMonYrTextField setText:[NSString stringWithFormat:@"%@/%@",curExpMon,curExpYear]];
    }
    ccTypeTextField.inputView=cardTypePicker;
}





#pragma mark - textfield functions

// Sets a character limit on cvv2 cell
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL length=NO;
    BOOL isDigit=NO;
    
    //check that the new character is a digit
    NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
       NSRange r = [string rangeOfCharacterFromSet:numSet];
    
    if(textField.tag == ccCCV2TextField.tag ){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
    length=((newLength > 4))?NO:YES;
    isDigit=(r.location !=NSNotFound|| range.length==1) ?YES:NO;
        
   
    return length && isDigit;
    }
    else {
        return YES;
    }
}
- (IBAction)backgroundTap:(id)sender{
    [expDatePicker resignFirstResponder];
    [exp resignFirstResponder];
   
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case CCTYPETAG:         currentTextfieldString=   ccTypeTextField.text;break;
        case CCFNAMETAG:        currentTextfieldString=   ccFNameTextField.text;break;
        case CCLNAMETAG:        currentTextfieldString=   ccLNameTextField.text;break;
        case CCNUMTAG:          currentTextfieldString=   ccNumTextField.text;break;
        case CCEXPMOYRTAG:      currentTextfieldString=   ccExpMonYrTextField.text;break;
        case CCCCV2TAG:         currentTextfieldString=   ccCCV2TextField.text;break;
        case ADD_TONAMETAG:     currentTextfieldString=   toNameTextField.text;break;
        case ADD_ADDRESS1TAG:   currentTextfieldString=   address1TextField.text;break;
        case ADD_ADDRESS2TAG:   currentTextfieldString=   address2TextField.text;break;
        case ADD_CITYTAG:       currentTextfieldString=   cityTextField.text;break;
        case ADD_STATETAG:      currentTextfieldString=   stateTextField.text;break;
        case ADD_ZIPTAG:        currentTextfieldString=   zipTextField.text;break;
    }
    if([currentTextfieldString isKindOfClass:[NSNull class]])
        currentTextfieldString=@"";
    
    //get the bounds of the text field and the view
    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    
    //    find the midline
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];

    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
     
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
 
    if([textField.text  isEqualToString:@""]){
        textField.text = currentTextfieldString;
        currentTextfieldString=@" ";
    }
    switch (textField.tag) {
        case CCTYPETAG:     ccTypeTextField.text=       textField.text;break;
        case CCFNAMETAG:    ccFNameTextField.text=      textField.text;break;
        case CCLNAMETAG:    ccLNameTextField.text=      textField.text;break;
        case CCNUMTAG:      ccNumTextField.text=        textField.text;break;
        case CCEXPMOYRTAG:  ccExpMonYrTextField.text=   textField.text;break;
        case CCCCV2TAG:     ccCCV2TextField.text=       textField.text;break;
        case ADD_TONAMETAG: toNameTextField.text=       textField.text;break;
        case ADD_ADDRESS1TAG:address1TextField.text=    textField.text;break;
        case ADD_ADDRESS2TAG:address2TextField.text=    textField.text;break;
        case ADD_CITYTAG:   cityTextField.text=         textField.text;break;
        case ADD_STATETAG:  stateTextField.text=        textField.text;break;
        case ADD_ZIPTAG:    zipTextField.text=          textField.text;break;
        default:break;
    }
  
     
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
                 

   }
     

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:ccNumTextField]) {
         ccTypeTextField.text=[validator whatIsThisCardType:ccNumTextField.text];
    }

    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textFieldDoneEditing:(id)sender{
     
    [ccTypeTextField    resignFirstResponder];
    [ccFNameTextField   resignFirstResponder];
    [ccLNameTextField   resignFirstResponder];
    [ccNumTextField     resignFirstResponder];
    [ccExpMonYrTextField  resignFirstResponder];
    [ccCCV2TextField    resignFirstResponder];
    
    [toNameTextField    resignFirstResponder];
    [address1TextField  resignFirstResponder];
    [address2TextField  resignFirstResponder];
    [cityTextField      resignFirstResponder];
    [stateTextField     resignFirstResponder];
    [zipTextField       resignFirstResponder];

    ////
    [cardTypePicker resignFirstResponder];
    [expDatePicker resignFirstResponder];
    [statesPicker resignFirstResponder];
    [stateTextField resignFirstResponder];
    
    [ccExpMonYrTextField resignFirstResponder];

    [self resignFirstResponder];
}

-(void)textFieldDidChange:(id)textField{
    NSString *cardType;

    if([textField isEqual:ccNumTextField])
       cardType = [validator whatIsThisCardType:((UITextField*)textField).text];
    else if([textField isKindOfClass:[NSString class]])  {
        cardType = textField;
        textField  =ccNumTextField;
        NSLog(@"%@ %@",textField,cardType);
        }
    
    if([cardType isEqualToString:@"Visa"]){
        [((UIImageView*)[[textField superview] viewWithTag:80]) setHidden:NO];
        ((UIImageView*)[[textField superview] viewWithTag:80]).image = [UIImage imageNamed:@"VisaCard.png"];
    }
    else if([cardType isEqualToString:@"American Express"]){
        [((UIImageView*)[[textField superview] viewWithTag:80]) setHidden:NO];
        ((UIImageView*)[[textField superview] viewWithTag:80]).image = [UIImage imageNamed:@"AmexCard.png"];
    }
    else if([cardType isEqualToString:@"Discover"]){
       [((UIImageView*)[[textField superview] viewWithTag:80]) setHidden:NO];
        ((UIImageView*)[[textField superview] viewWithTag:80]).image = [UIImage imageNamed:@"DiscoverCard.png"];
    }
    else if([cardType isEqualToString:@"Mastercard"]){
       [((UIImageView*)[[textField superview] viewWithTag:80]) setHidden:NO];
        ((UIImageView*)[[textField superview] viewWithTag:80]).image = [UIImage imageNamed:@"Mastercard.png"];
    }
   else {
       [[textField superview] viewWithTag:80].hidden=YES;
   }
    ccTypeTextField.text=cardType;     
    }

 

#pragma Mark    VALIDATION


    -(void)backButtonPressed{
        if(((self.accountOption==NEWCC) && ([appDel.wallet count]==0)) ||((self.accountOption==NEWADDRESS) && ([appDel.addressBook count]==0)))
        [self.navigationController popToRootViewControllerAnimated:YES];
        else
            [self.navigationController popViewControllerAnimated:YES];
        
    }

-(void)primaryButtonPressed:(UIButton*)sender{
        if([sender isSelected])
        [sender setSelected:NO];
        else
        [sender setSelected:YES];

        
}   
@end