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
#define CCTYPETAG   0
#define CCFNAMETAG 1
#define CCLNAMETAG 2
#define CCNUMTAG 3
#define CCEXPMOYRTAG 4
#define CCCCV2TAG 5

//define Address Lable tags
#define ADD_TONAMETAG 6
#define ADD_ADDRESS1TAG 7
#define ADD_CITYTAG 8
#define ADD_STATETAG 9
#define ADD_ZIPTAG 10
#define ADD_PRITAG 11



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
@synthesize primaryAddressSwitch;
//Address textFields
@synthesize toNameTextField,
            address1TextField,
            cityTextField,
            stateTextField,
            zipTextField;

//Arrays
@synthesize pickerMonths,pickerYears,
            CCLabels,CCTextFields,ccTypes,
            addressLabels,addressTextFields,states;

//****strays to be removed
@synthesize expDatePicker,cardTypePicker,statesPicker;
@synthesize curExpMon,curExpYear;

@synthesize exp;

@synthesize delegate;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            curExpMon=@"";
            curExpYear=@"";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action: @selector(backButtonPressed)];
        newBackButton.tintColor = [UIColor blackColor];

        
        [[self navigationItem] setLeftBarButtonItem: newBackButton];

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
 
    self.appDel = [[UIApplication sharedApplication]delegate];
    

    addressSwitchBool=YES;

    // set up Address Switch
    addressSwitch = [[UISegmentedControl alloc]  
                     initWithItems:
                     [NSArray arrayWithObjects:@"Address Book",@"Edit Current",nil]];
    
    [addressSwitch addTarget:self 
                      action:@selector(addressSwitched:) 
            forControlEvents:UIControlEventValueChanged];
 
    [addressSwitch setFrame:CGRectMake(8, 0, 302, 45)];
   
    [addressSwitch setSelectedSegmentIndex:0];
    ////
// try getting the states 
    NSString *statesPath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];

    NSDictionary* statesArray = [[NSDictionary alloc]initWithContentsOfFile:statesPath];
    
 
    
    states=[[NSArray alloc] initWithArray:[statesArray allKeys]];
    
    states=[states sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

//
    
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
    ccTypes = [[NSArray alloc]initWithObjects:@"American Express",@"Discover",@"MasterCard",@"Visa",@"Other", nil];
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
    CCLabels = [[NSArray alloc] initWithObjects:@"Credit Card Type",
                                                @"First Name",
                                                @"Last Name",
                                                @"CreditCard #",
                                                @"Exp Month / Year",
                                                @"CVV2", nil];    
   
        ccTypeTextField   = [[UITextField alloc] init];
        ccFNameTextField  = [[UITextField alloc] init];
        ccLNameTextField  = [[UITextField alloc] init];
        ccNumTextField    = [[UITextField alloc] init];
        ccExpMonYrTextField = [[UITextField alloc] init];
        ccExpMonYrTextField.inputView=expDatePicker;
        ccCCV2TextField   = [[UITextField alloc] init];
  
 
       
   ////
    
    //Address Labels and TextFields
        addressLabels = [[NSArray alloc] initWithObjects:@"To Name",
                                                         @"Address1",
                                                         @"City",
                                                         @"State",
                                                         @"Zip",
                                                        @"Primary Address ?",
                                                         nil]; 
                                            
        toNameTextField   = [[UITextField alloc] init];
        address1TextField = [[UITextField alloc] init];
        cityTextField     = [[UITextField alloc] init];
        stateTextField    = [[UITextField alloc] init];
        zipTextField      = [[UITextField alloc] init];
    primaryAddressSwitch =[[UISwitch alloc ]initWithFrame:CGRectMake(225, 8, 79, 27)];
       ////
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void)viewWillAppear:(BOOL)animated{
     
    self.view = editItemTableView;

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
    saveButton.tintColor = [UIColor blueColor];
    
    
    // Switch handles which view to display in the controller;
    switch (self.accountOption) {
            
    //Edit Creditcard View
        case EDITCC:{
            
            self.navigationItem.title = @"Edit Credit Card";
          
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
            
            
            
            //add all the text fields to an array
            CCTextFields =[[NSArray alloc] initWithObjects:ccTypeTextField,
                                                           ccFNameTextField,
                                                           ccLNameTextField,
                                                           ccNumTextField,
                                                           ccExpMonYrTextField,
                                                           ccCCV2TextField, nil];
                                            
            //set the tag for each textfield
            for (int i=0;i<[CCTextFields count];i++){
                [((UITextField*)[CCTextFields objectAtIndex:i])setTag:i];
                if (![((UITextField*)[CCTextFields objectAtIndex:i])isEqual:ccExpMonYrTextField]) {
                    [((UITextField*)[CCTextFields objectAtIndex:i])setEnabled:NO];
                }
            }
            
            //Load the address info
            // set the credit card billing information to the text fields.
            toNameTextField.text =  currentCreditCard.billingAddress.toName;
            address1TextField.text= currentCreditCard.billingAddress.address1;
            cityTextField.text =    currentCreditCard.billingAddress.city;
            stateTextField.text =   currentCreditCard.billingAddress.state;
            zipTextField.text =     currentCreditCard.billingAddress.zip;
            
            addressTextFields = [[NSArray alloc]initWithObjects:
                                                 toNameTextField,
                                                 address1TextField,
                                                 cityTextField,
                                                 stateTextField,
                                                 zipTextField, nil];
                                            
            for (int i=0;i<[addressTextFields count];i++)
                [((UITextField*)[addressTextFields objectAtIndex:i])setTag:i+6];
            

            //add the Save Button to the view  
            [saveButton setAction:@selector(saveCreditcard:)];
            self.navigationItem.rightBarButtonItem = saveButton;
            break;
        }
            
        
        case NEWCC:{
            self.navigationItem.title = @"New Credit Card";
           
            //CC Textfields
            //Creating a new creditcard here, so leave the fields blank and add them to the array
            CCTextFields =[[NSArray alloc] initWithObjects:ccTypeTextField,
                           ccFNameTextField,
                           ccLNameTextField,
                           ccNumTextField,
                           ccExpMonYrTextField,
                           ccCCV2TextField, nil];
            
            //set all cc textfield tags
            for (int i=0;i<[CCTextFields count];i++)
                [((UITextField*)[CCTextFields objectAtIndex:i])setTag:i];
            
            
            //address textfields
            addressTextFields = [[NSArray alloc]initWithObjects:
                                 toNameTextField,
                                 address1TextField,
                                 cityTextField,
                                 stateTextField,
                                 zipTextField, nil];
            
            //set the address textfields tags
            for (int i=0;i<[addressTextFields count];i++)
                [((UITextField*)[addressTextFields objectAtIndex:i])setTag:i+6];
            

  
            //Save Button  
            [saveButton setAction:@selector(saveCreditcard:)];
            self.navigationItem.rightBarButtonItem = saveButton;
 
            break;
        }

            //Edit Address View      
        case EDITADDRESS:{
            self.navigationItem.title = @"Edit Address";

            // Load the current address information into the text fields
            toNameTextField.text = currentAddress.toName;
            address1TextField.text=currentAddress.address1;
            cityTextField.text = currentAddress.city;
            stateTextField.text = currentAddress.state;
            zipTextField.text = currentAddress.zip;
            if(currentAddress.primary )
                [primaryAddressSwitch setOn:YES];
            else
                [primaryAddressSwitch setOn:NO];
            
            // add all the textfields to the array
            addressTextFields = [[NSArray alloc]initWithObjects:
                                 toNameTextField,
                                 address1TextField,
                                 cityTextField,
                                 stateTextField,
                                 zipTextField, 
                                 primaryAddressSwitch, nil];
            
            // set the tags for the address tet fields 
            for (int i=0;i<[addressTextFields count]-1;i++)
                [((UITextField*)[addressTextFields objectAtIndex:i])setTag:i+6];
          [((UISwitch*)[addressTextFields objectAtIndex:[addressTextFields count]-1]) setTag:ADD_PRITAG];
            
           // add the save button
            [saveButton setAction:@selector(saveAddress:)];
                      self.navigationItem.rightBarButtonItem = saveButton;
            break;
        }
            
        case NEWADDRESS:
            self.navigationItem.title = @"New Address";
            // creating a new address so just load the empty text fields
            addressTextFields = [[NSArray alloc]initWithObjects:
                                 toNameTextField,
                                 address1TextField,
                                 cityTextField,
                                 stateTextField,
                                 zipTextField, 
                                 primaryAddressSwitch, nil];
            
            // set the tags for the address tet fields 
            for (int i=0;i<[addressTextFields count]-1;i++)
                [((UITextField*)[addressTextFields objectAtIndex:i])setTag:i+6];
            [((UISwitch*)[addressTextFields objectAtIndex:[addressTextFields count]-1]) setTag:ADD_PRITAG];
            
            
            [saveButton setAction:@selector(saveAddress:)];
            self.navigationItem.rightBarButtonItem = saveButton;
            break;  
            

        default:
            break;
    }

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
       return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(accountOption== EDITCC|| accountOption == NEWCC){
        return 3;//Credit Card Section, Segmented Control Section,AddressSection
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
        if(section ==2){
            if(addressSwitchBool)
                return [appDel.addressBook count];
            else
                return [addressTextFields count];
            
        }
    }
    
    else if(accountOption == EDITADDRESS||accountOption == NEWADDRESS )
        return [addressLabels count];
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //if user is selecting an existing address make a bigger cell
    if([indexPath section]==2 && addressSwitchBool) return 90.0;
    else return 44.0;
    
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel=[[UILabel alloc]init];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor colorWithRed:57.0f/255.0f green:171.0f/255.0f blue:236.0f/255.0f alpha:1.0f]];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
    if(section==0)
    [headerLabel setText:@"Credit Card Information"];
    if(section==0 && accountOption==NEWADDRESS||accountOption==EDITADDRESS)
        [headerLabel setText:@"Address Information"];
    if(section==2)
        [headerLabel setText:@"Address Information"];

    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell ;
    NSUInteger row = [indexPath row];
    
    
    // If the view is laoding the Segemented control section
    if([indexPath section]==1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"addressSwitchCell"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressSwitchCell" 
                        owner:self 
                        options:nil];
        
        if ([nib count] > 0) {
            cell = self.addressSwitchCell;
            [addressSwitch setSegmentedControlStyle:UISegmentedControlStyleBar];
          
            [cell addSubview:addressSwitch];
            }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
    }
  
    // If the user is choosing from an exisitng address; load address cells in 
    // bottom section.
    
    else if((accountOption== EDITCC|| accountOption == NEWCC) && 
       ([indexPath section]==2) &&
       (addressSwitchBool)){
                  
            CellIdentifier=@"AddressCellIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
           cell = [topLevelObjects objectAtIndex:0];
           
        
            UILabel *primaryLabel = (UILabel *)[cell viewWithTag:5];
            primaryLabel.hidden = YES;
            
            //nameLabel
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:10];
            nameLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[appDel.addressBook objectAtIndex:row]).toName ];
            
            UILabel *addressLabel = (UILabel *)[cell viewWithTag:20];
            addressLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[appDel.addressBook  objectAtIndex:row]).address1 ];
            
            UILabel *cityStateZipLabel = (UILabel *)[cell viewWithTag:30];
            cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", ((Address*)[appDel.addressBook  objectAtIndex:row]).city,((Address*)[appDel.addressBook  objectAtIndex:row]).state,((Address*)[appDel.addressBook  objectAtIndex:row]).zip ];
            
        //check if the current address matches the address in the row
        if ([ currentCreditCard.billingAddress addressIsEqualto:[appDel.addressBook objectAtIndex:row]]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;        
            }
            
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

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
      
    // modify the new cell
        if(accountOption== EDITCC|| accountOption == NEWCC){
            
            //if the view is loading the cc section
            if([indexPath section]==0){
                 //set the textfields tag and text   
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
                    ccTypeTextField=editTextField;

                }
                
                if(editTextField.tag==CCNUMTAG){
                    [editTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    [editTextField setDelegate:self];
                    [editTextField setText:ccNumTextField.text];
                    if (accountOption==EDITCC) {//hide the cc number
                        //bullet (U+2022)
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
                }
                
                
                //set the labels text  
                editCellLabel.text = [CCLabels objectAtIndex:row];
                //set if its editable
                [editTextField setEnabled:[((UITextField*)[CCTextFields objectAtIndex:row])isEnabled ]];
                if(![editTextField isEnabled]){
                    [editTextField setTextColor:[UIColor grayColor]];
                }
            
            }
        
            else if([indexPath section]==2){    
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
                    stateTextField = editTextField;
                }
                 
            } 
            
        }
                
        
    
    else if(accountOption ==EDITADDRESS|| accountOption ==NEWADDRESS){
  
        if([[addressTextFields objectAtIndex:row] isKindOfClass:[UISwitch class]]){
            editTextField.hidden=YES;
            [cell addSubview:primaryAddressSwitch];
            editCellLabel.text = [addressLabels objectAtIndex:row];
        }
        
        else{
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
                stateTextField = editTextField;
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
// if the user is selecting from the address book and row selected is in section 2 then set new address
    if([indexPath section]==2 && 
       (addressSwitchBool) && 
      ( (accountOption==EDITCC) ||(accountOption==NEWCC))){
        
        //set address information to the textfields
        
        toNameTextField.text=(((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).toName) ;
        
        
        address1TextField.text=((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).address1;
        cityTextField.text=((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).city;
        stateTextField.text=((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).state;
        zipTextField.text=((Address*)[appDel.addressBook objectAtIndex:[indexPath row]]).zip;
        
        //clear all other check marks and check of the selected row;
       
        for(int i = 0; i < [tableView numberOfRowsInSection:2]; i++){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[[indexPath indexPathByRemovingLastIndex]indexPathByAddingIndex: i]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }   

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO ;
}


#pragma Mark - BUTTON FUNCTIONS




-(IBAction)saveCreditcard:(id)sender{
    NSLog(@"Save Creditcard clicked");
    if([ccTypeTextField.text     length]==0 ||
       [ccFNameTextField.text    length]==0 ||
       [ccLNameTextField.text    length]==0 ||
       [ccNumTextField.text      length]==0 ||
       [ccExpMonYrTextField.text length]==0 ||
       [ccCCV2TextField.text     length]==0){
        
        [appDel displayErrorMsgToUserWithTitle:@"Missing Fields" andMsg:@"Please enter info in all the fields"];
        return;
    }
    
    //validate CC fields
    NSString *vError=[NSString stringWithFormat:@""];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:ccTypeTextField.text   andType:CCTYPETAG]]; 
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:ccFNameTextField.text  andType:CCFNAMETAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:ccLNameTextField.text  andType:CCLNAMETAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:ccNumTextField.text    andType:CCNUMTAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:ccCCV2TextField.text   andType:CCCCV2TAG]];
    
    
    //validate Address fields
    
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:toNameTextField.text    andType:ADD_TONAMETAG]]; 
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:address1TextField.text  andType:ADD_ADDRESS1TAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:cityTextField.text      andType:ADD_CITYTAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:stateTextField.text     andType:ADD_STATETAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:zipTextField.text       andType:ADD_ZIPTAG]];

    NSLog(@"VALIDATION ERROR: %@",vError);
    if(![vError isEqualToString:@""]){
        [appDel displayErrorMsgToUserWithTitle:@"woops!" andMsg:vError];
        return;
    }

    CreditCard *updatedCreditCard = 
                        [[CreditCard alloc ]initWithCCtype: ccTypeTextField.text
                                            cardfirstName:  ccFNameTextField.text 
                                            cardlastName:   ccLNameTextField.text 
                                            billfirstName:  toNameTextField.text 
                                            billlastName:   @""
                                            cardNumber:     ccNumTextField.text 
                                            expMonth:    
    [((NSArray*)[ccExpMonYrTextField.text componentsSeparatedByString:@"/"]) objectAtIndex:0] 
                         
                         
                                            expYear:        
    [((NSArray*)[ccExpMonYrTextField.text componentsSeparatedByString:@"/"]) objectAtIndex:1]
                                            cvv2:           ccCCV2TextField.text 
                                            toAddress1:     address1TextField.text 
                                            city:           cityTextField.text 
                                            state:          stateTextField.text 
                                            zip:            zipTextField.text
                                                 paymentID:(currentCreditCard.paymentID ==NULL)? NULL:currentCreditCard.paymentID
];
    

    NSLog(@"New credit card %@",updatedCreditCard);
    
    if(accountOption ==  EDITCC){
        if([appDel updateModifiedCreditCardToServer:updatedCreditCard andOldCreditcard:currentCreditCard]){
        [appDel displayErrorMsgToUserWithTitle:@"Success" andMsg:@"Your card was successfully updated"];
        }
        else
            [appDel displayErrorMsgToUserWithTitle:@"Oops" andMsg:@"Something went wrong when trying to update your credit card"];
    }

    if(accountOption == NEWCC){
        if([appDel UpdateNewCreditCardToServer:updatedCreditCard]){
            [appDel displayErrorMsgToUserWithTitle:@"Success" andMsg:@"Your card was successfully updated"];
        }
        else
            [appDel displayErrorMsgToUserWithTitle:@"Oops" andMsg:@"Something went wrong when trying to update your credit card"];
    }
    
        [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)saveAddress:(id)sender{
    NSLog(@"Save Address clicked");
   
//check if all fields are filled
    if([toNameTextField.text    length]==0 ||
       [address1TextField.text  length]==0 ||
       [cityTextField.text      length]==0 ||
       [stateTextField.text     length]==0 ||
       [zipTextField.text       length]==0){
        
        [appDel displayErrorMsgToUserWithTitle:@"Missing Fields" andMsg:@"Please enter info in all the fields"];
        return;
    }
    
    //validate all fields
    NSString *vError=[NSString stringWithFormat:@""];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:toNameTextField.text    andType:ADD_TONAMETAG]]; 
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:address1TextField.text  andType:ADD_ADDRESS1TAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:cityTextField.text      andType:ADD_CITYTAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:stateTextField.text     andType:ADD_STATETAG]];
    vError=[vError stringByAppendingFormat:@"%@",[self validateInput:zipTextField.text       andType:ADD_ZIPTAG]];
    
    NSLog(@"VALIDATION ERROR: %@",vError);
    if(![vError isEqualToString:@""]){
        [appDel displayErrorMsgToUserWithTitle:@"woops!" andMsg:vError];
        return;
    }
    
    Address *updatedAddress=[[Address alloc]initWithName:toNameTextField.text 
                                            address1:address1TextField.text 
                                            city:cityTextField.text 
                                            state:stateTextField.text 
                                            zip:zipTextField.text 
                                                 primary:(primaryAddressSwitch.isOn)?YES:NO 
                                                  withID:(currentAddress.addressID ==NULL)? NULL:currentAddress.addressID];
    NSLog(@"New Address %@",updatedAddress);
   
    if (accountOption == EDITADDRESS) {
        if([appDel updateModifiedAddressToServer:updatedAddress andOldAddress:currentAddress]){[self.navigationController popViewControllerAnimated:YES];}
    }
    else if(accountOption == NEWADDRESS){
        if([appDel updateNewAddressToServer:updatedAddress]){[self.navigationController popViewControllerAnimated:YES];}
    }
        
}

-(IBAction)addressSwitched:(UISegmentedControl*)sender{
   
    if (sender.selectedSegmentIndex ==0)
        addressSwitchBool=YES;
        else
        addressSwitchBool=NO;

    [editItemTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];

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
        
        return [NSString stringWithFormat:@"               %@",[states objectAtIndex:row]];
    }
    
    if (component==0) {
        return [pickerMonths objectAtIndex:row];
    }
    else 
        return [pickerYears objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{    
    
    [expDateTimer invalidate];
    if([pickerView isEqual:cardTypePicker]) {
        ccTypeTextField.text=[ccTypes objectAtIndex:row];
        if([ccTypeTextField.text isEqualToString:@"Other"]){
            ccTypeTextField.text=@""; 
#warning finish loading keyboard   
            [ccTypeTextField resignFirstResponder];
            ccTypeTextField.inputView=NULL;
            [ccTypeTextField setKeyboardType:UIKeyboardTypeDefault];
   
                
          [ccTypeTextField becomeFirstResponder];
        }
        else{
         [ccTypeTextField resignFirstResponder];
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
    expDateTimer = [NSTimer scheduledTimerWithTimeInterval:1.75 target:self selector:@selector(textFieldDoneEditing:) userInfo:nil repeats:NO];
    
}





#pragma Mark - textfield functions
- (IBAction)backgroundTap:(id)sender{
    [expDatePicker resignFirstResponder];
    [exp resignFirstResponder];
   
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
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
/*
    NSString* inputString=[self validateInput:textField.text andType:textField.tag];
    NSRange errange =  [inputString rangeOfString:@"ERROR:"];   
    if(errange.length>0){
        NSLog(@"%@",[inputString substringFromIndex:(errange.location+ errange.length)]);
    }
    else{
 */
    switch (textField.tag) {
        case CCTYPETAG:     ccTypeTextField.text=       textField.text;break;
        case CCFNAMETAG:    ccFNameTextField.text=      textField.text;break;
        case CCLNAMETAG:    ccLNameTextField.text=      textField.text;break;
        case CCNUMTAG:      ccNumTextField.text=        textField.text;break;
        case CCEXPMOYRTAG:  ccExpMonYrTextField.text=   textField.text;break;
        case CCCCV2TAG:     ccCCV2TextField.text=       textField.text;break;
        case ADD_TONAMETAG: toNameTextField.text=       textField.text;break;
        case ADD_ADDRESS1TAG:address1TextField.text=    textField.text;break;
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

#pragma Mark    VALIDATION

-(NSString*)validateInput:(NSString*)input
                  andType:(int)type{
    NSLog(@"in validation");
    NSString *errorString=@"";
    BOOL checkZipOrState = NO;
    BOOL stateIsValid,zipIsValid =NO;
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. "];
    
    charSet = [charSet invertedSet];
    
    NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    numSet = [numSet invertedSet];
  
     
    switch (type) {
        case CCTYPETAG:break;
            
        case CCCCV2TAG:{
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:@"CCV2 must be digits"];
            }

            if(!([input length]==3 ||[input length]==4)){
                errorString=[errorString stringByAppendingFormat:@"CCV2 is not the right length"];
            }
            break;   
            
        }
        case CCNUMTAG:
            if(![self creditcardIsValidWith:ccTypeTextField.text andCcNumber:ccNumTextField.text andCCV2:ccCCV2TextField.text]){
                  errorString=[errorString stringByAppendingFormat:@"Please Check your CC number"];
                
            }
            break;   
            
        case (ADD_TONAMETAG):
        case (CCFNAMETAG):
        case (CCLNAMETAG):
        {
            //Make sure the name is all characters
            NSRange r = [input rangeOfCharacterFromSet:charSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:@"Name must only contain characters"];
                }
            if ([input length]>32) {
                 errorString=[errorString stringByAppendingFormat:@"ToName must be shorter than 32 characters"];
            }
            break;
            }
    
        case ADD_ADDRESS1TAG:{
            //Nothing to see here folks
            break;
        }
        case ADD_CITYTAG:{    
            //Nothing to see here folks
            break;
        }
        case ADD_STATETAG:{
            
            if(![states containsObject:input]){
                errorString=[errorString stringByAppendingFormat:@"Use the states picker!"];
                checkZipOrState=NO;
                stateIsValid=NO;
            }
            else{
                checkZipOrState=YES;
                stateIsValid=YES;
            }
                
            
            
                break;
        }
        case ADD_ZIPTAG:{
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:@"zipcode must be digits"];
            }
            if([input length]!=5){
                    errorString=[errorString stringByAppendingFormat:@"Mistyped Zipcode"];
                checkZipOrState=NO;
                zipIsValid=NO;
            }
            else{
            checkZipOrState=NO;
           zipIsValid=NO;
            }
                break;
            
        }
        default:errorString=[errorString stringByAppendingFormat:@"- Add Validation for textfield of type %d",type];
            break;
        
        
    }
    
    if(checkZipOrState){
        BOOL zipIsOK;
        //check the zipcode and the state match up
        NSString *statesPath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
        
        NSDictionary* statesDict = [[NSDictionary alloc]initWithContentsOfFile:statesPath];

        NSArray *zipArray=   [[statesDict valueForKey:stateTextField.text]componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];

        
        
        for(int i=1;i<[zipArray count];i++){
           // if the string has a - its a range
            if(([[zipArray objectAtIndex:i]rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]].location!=NSNotFound)){
            
                 NSArray *zipRange= [[zipArray objectAtIndex:i]componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];

                zipIsOK=[self zipCode:[[zipTextField.text substringToIndex:3] intValue] isBetween:[[zipRange objectAtIndex:0]intValue] and:[[zipRange objectAtIndex:1]intValue]];
                if(zipIsOK)break;
            }
            else{
                  zipIsOK=[self zipCode:[[zipTextField.text substringToIndex:3] intValue] isBetween:[[zipArray objectAtIndex:i]intValue] and:-1];
                if(zipIsOK)break; 
                
            }
        }
        if (!(zipIsOK)) {
            errorString=[errorString stringByAppendingFormat:@"Your zipcode and your state dont match"];

        }   
                
    }
    
    return errorString;
}
-(BOOL)zipCode:(int)code isBetween:(int)low and:(int)high{

    
    if(high!=-1){
        if((code>=low) && (code<=high))
            return YES;
        else
            return NO;
    }
    else{
            if(code==low)
                return YES;
            else
                return NO;
        }
   
}



-(BOOL)creditcardIsValidWith:(NSString*)ccType
                 andCcNumber:(NSString*)ccNumber
                     andCCV2:(NSString*)ccV2{
    BOOL ccisValid=NO;
    //check number
    if ([ccType isEqualToString:@"American Express"]) {// American Express: length 15, prefix 34 or 37.
        if([ccNumber length]==15){
          if (([[ccNumber substringToIndex:2]intValue]==34) ||
              ([[ccNumber substringToIndex:2]intValue]==37)){ 
            ccisValid= YES;
          }
        }
        else 
            return NO;

        
    }
    else if([ccType isEqualToString:@"Discover"]) { // Discover: length 16, prefix 6011
        if(([ccNumber length]==16)&&
           [[ccNumber substringToIndex:4]isEqualToString:@"6011"])
             ccisValid= YES;
        else return NO;
        
    }
    else if([ccType isEqualToString:@"MasterCard"]) {//// Mastercard: length 16, prefix 51-55
        if([ccNumber length]==16){
            if(([[ccNumber substringToIndex:2]intValue]>=51) &&
            ([[ccNumber substringToIndex:2]intValue]<=55)){ 
            ccisValid= YES;
             }
        }
        else 
            return NO;
        
        
    }
    else if([ccType isEqualToString:@"Visa"]) {//// Visa: length 16, prefix 4,
        if(([ccNumber length]==16)&&
           [ccNumber characterAtIndex:0]=='4')
           ccisValid= YES;
        else
            return NO;
    }
    else{
        NSLog(@"Dont know this type of card so there is no validation for it.");
        ccisValid=YES;
    
    }
    //no ccv2  checking at this time
    
    
    
    return ccisValid;
}
                        
    -(void)backButtonPressed{
        if(((self.accountOption==NEWCC) && ([appDel.wallet count]==0)) ||((self.accountOption==NEWADDRESS) && ([appDel.addressBook count]==0)))
        [self.navigationController popToRootViewControllerAnimated:YES];
    
        else
            [self.navigationController popViewControllerAnimated:YES];
        
    }
@end









