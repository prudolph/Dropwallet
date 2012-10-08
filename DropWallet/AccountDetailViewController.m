//
//  AccountDetailViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define PERSONALSETTINGS 0
#define CHANGEPASSWORD 1
#define PAYMENTMETHODS 2
#define ADDRESSBOOK 3


#define EDITCC 4
#define EDITADDRESS 5
#define NEWADDRESS 6
#define NEWCC 7
#define EDITCCADDRESS 8 

// Button tags
#define CURRENTPASSTAG 1
#define NPASSTAG 2
#define NPASS2TAG 3
#define USERFNAMETAG 4
#define USERLNAMETAG 5
#define USEREMAILTAG 6

#import "AccountDetailViewController.h"
#import "AppDelegate.h"
#import "EditItemViewController.h"
#import "Address.h"
#import "CreditCard.h"
@implementation AccountDetailViewController

//Arrays
@synthesize currentArray,
            passwordLabelArray,
            passwordTextFieldArray,
            personalLabelArray,
            personalTextfieldArray;

@synthesize accountOption,rowforDeletion;
@synthesize cclogos;
@synthesize currentPass,
            nPass,
            nPass2,
            userFName,
            userLName,
            userEmail;
@synthesize currentTextString;
@synthesize appDel;
@synthesize accountDetailTableView;
@synthesize ccTableViewCell,addressTableViewCell,editTableViewCell;
@synthesize editPassAlert,confirmDelete;
@synthesize editItemViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        self.currentTextString = [[NSString alloc]init];
        self.currentArray = [[NSArray alloc]init];
        

    }
            return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 self.appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    [appDel.logoImgView setHidden:YES];
        UIBarButtonItem *newButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newItem:)];
       [newButton setTintColor:[UIColor darkGrayColor]];
 
    [self.accountDetailTableView setSeparatorColor:[UIColor colorWithRed:221.0f/255.0 green:223.0f/255 blue:223.0f/255 alpha:1]];
    

  // load in cc logos
    cclogos = [[NSMutableDictionary alloc] init];
    [cclogos setValue:[UIImage imageNamed:@"DiscoverCard.png"] forKey:@"Discover"];
    [cclogos setValue:[UIImage imageNamed:@"VisaCard.png"]     forKey:@"Visa"]; 
    [cclogos setValue:[UIImage imageNamed:@"MasterCard.png"]   forKey:@"MasterCard"]; 
    [cclogos setValue:[UIImage imageNamed:@"AmexCard.png"]     forKey:@"American Express"]; 
          self.title =  [appDel.appText objectForKey:@"Account_View-Title"];
  confirmDelete =[[UIAlertView alloc]initWithTitle:@"Confirm Delete" message:@"Are you sure you want to remove this item?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil]; 
    switch ((NSInteger ) accountOption)
    
    {
        case PERSONALSETTINGS:{

            //Setup for Personal Info arrays
            personalLabelArray=[[NSArray alloc] initWithObjects:[appDel.appText objectForKey:@"Personal_Settings-Fname_Lbl"],
                                [appDel.appText objectForKey:@"Personal_Settings-Lname_Lbl"],
                                [appDel.appText objectForKey:@"Personal_Settings-Email_Lbl"], nil];
            userFName=[[UITextField alloc]init] ;
            [userFName setTag:USERFNAMETAG];
            [userFName setText:[appDel.accountInfo objectForKey:@"fName"]];
           
            userLName=[[UITextField alloc]init] ;
            [userLName setTag:USERLNAMETAG];
            [userLName setText:[appDel.accountInfo objectForKey:@"lName"]];
            
            userEmail=[[UITextField alloc]init] ;
            [userEmail setTag:USEREMAILTAG];
            [userEmail setText:[appDel.keychain objectForKey:(__bridge id)kSecAttrAccount]];
            [userEmail setEnabled:NO];
            
            
            ////
            personalTextfieldArray = [[NSArray alloc] initWithObjects:userFName,userLName,userEmail, nil];
             
            //Save personal Info Button
            UIBarButtonItem *savePersonalInfoButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePersonalInfo:)];

            [savePersonalInfoButton setTintColor:[UIColor colorWithWhite:.55 alpha:1]];
    
            


            self.currentArray=personalLabelArray;

            self.navigationItem.rightBarButtonItem=savePersonalInfoButton;
            break;
        }
        case CHANGEPASSWORD:{
                       //Setup for Password view arrays 
            
            currentPass=[[UITextField alloc]init] ;
            [currentPass setTag:CURRENTPASSTAG];
            [currentPass setPlaceholder:@""];
            
            nPass=[[UITextField alloc]init] ;
            [nPass setTag:NPASSTAG];
            
            nPass2=[[UITextField alloc]init] ;
            [nPass2 setTag:NPASS2TAG];
            
            passwordTextFieldArray=[[NSArray alloc] initWithObjects:currentPass ,nPass,nPass2,nil];
            passwordLabelArray=[[NSArray alloc] initWithObjects: [appDel.appText objectForKey:@"Change_Password-Current_Lbl"],
                                 [appDel.appText objectForKey:@"Change_Password-NewPass_Lbl"],
                                 [appDel.appText objectForKey:@"Change_Password-Confirm_Lbl"], nil];
            
            //Save Password Button
            UIBarButtonItem *upDatePassButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updatePass:)];
            [upDatePassButton setTintColor:[UIColor colorWithWhite:.55 alpha:1]];
            
            self.currentArray=passwordLabelArray;
            self.navigationItem.rightBarButtonItem=upDatePassButton;
            break;
        }
        case PAYMENTMETHODS:{
             [self.accountDetailTableView setSeparatorColor:[UIColor whiteColor]];
            self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] wallet];
      
           
            
                self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] wallet];
            
                self.navigationItem.rightBarButtonItem=newButton;
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
            self.navigationItem.backBarButtonItem= newBackButton;
            break;   
        }
        case ADDRESSBOOK:{
             [self.accountDetailTableView setSeparatorColor:[UIColor whiteColor]];
             self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] addressBook];
            self.navigationItem.rightBarButtonItem=newButton;
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
            self.navigationItem.backBarButtonItem= newBackButton;

            break;

        }
        default:
          
            break;
            
    }
      self.navigationItem.leftBarButtonItem.title=@"Back";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   // self.currentArray = nil;
   // self.accountDetailTableView = nil;
   // self.editTableViewCell=nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *sortingArray = [[NSMutableArray alloc]init];
    if (accountOption==PAYMENTMETHODS){
        for (CreditCard *c in appDel.wallet){
            if(c.isPrimary){
                [sortingArray insertObject:c atIndex:0];
            }
                else{
                    [sortingArray addObject: c ];
                }
                }
            
            self.currentArray = sortingArray;
    
        }
    else if (accountOption ==ADDRESSBOOK){
        for (Address *a in appDel.addressBook){
            if(a.primary){
                [sortingArray insertObject:a atIndex:0];
            }
            else {
                [sortingArray addObject: a];

            }
        }

        self.currentArray = sortingArray;
    }


    
    [super viewWillAppear:animated];
      [self.accountDetailTableView reloadData];
  
}

- (void)viewDidAppear:(BOOL)animated
{
   
    [super viewDidAppear:animated];

    if([[self class] isEqual:[AccountDetailViewController class]]){
    NSString *noEntriesTtl;
    NSString *noEntriesMsg=[NSString stringWithFormat:@"%@",[appDel.appText objectForKey:@"No_Entries_Alert-Msg"]];
    
    
   
    if([currentArray count]==0){
        if(accountOption==PAYMENTMETHODS){
            noEntriesTtl=[NSString stringWithFormat:@"%@",[appDel.appText objectForKey:@"No_Entries_Alert-CC_Title"]];
            
        }
        else if(accountOption==ADDRESSBOOK){
            noEntriesTtl=[NSString stringWithFormat:@"%@",[appDel.appText objectForKey:@"No_Entries_Alert-Address_Title"]];
        }  
    
        
        UIAlertView *emptyArrayAlert = [[UIAlertView alloc]initWithTitle:noEntriesTtl message:noEntriesMsg delegate:self cancelButtonTitle:[appDel.appText objectForKey:@"No_Entries_Alert-No_btn"] otherButtonTitles:[appDel.appText objectForKey:@"No_Entries_Alert-Yes_btn"], nil];

      if(![appDel.generalAlert isVisible]){
        [emptyArrayAlert show];
        }
    
        
    }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        UILabel *headerLabel=[[UILabel alloc]init];
        [headerLabel setBackgroundColor:[UIColor clearColor]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        [headerLabel setTextAlignment:UITextAlignmentCenter];
        headerLabel.frame=CGRectMake(10, 6, 300, 40);
      
        switch ((NSInteger ) accountOption)
        
        {
            case PERSONALSETTINGS:[headerLabel  setText:@"PERSONAL SETTINGS"];break;
            case CHANGEPASSWORD:[headerLabel    setText:@"CHANGE PASSWORD"];break;
            case PAYMENTMETHODS:[headerLabel    setText:@"PAYMENT METHODS"];break;
            case ADDRESSBOOK:[headerLabel       setText:@"ADDRESS BOOK"];break;
        }    

                
        
        UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
        [headerView addSubview:headerLabel ];
        
        return headerView;
    }
    else return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier;
    UITableViewCell *cell ;
    NSUInteger row = [indexPath row];
    
         
    switch (accountOption)
    
    {
        case PERSONALSETTINGS:{
            CellIdentifier=@"editCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditCell" owner:self options:nil];
                if ([nib count] > 0) 
                    cell = self.editTableViewCell;
                else 
                    NSLog(@"failed to load MessageCell nib!");
            }
        
            UILabel *editCellLabel = (UILabel *)[cell viewWithTag:40];
            editCellLabel.text = [currentArray objectAtIndex:row];
            
            //create the password text fields and set the textfield tag based on the row in the tableview
            
            UITextField *editTextField = (UITextField*)[cell viewWithTag:50];
            [editTextField setTag:((UITextField*)[personalTextfieldArray objectAtIndex:row]).tag];
            [editTextField setText:((UITextField*)[personalTextfieldArray objectAtIndex:row]).text];
            [editTextField setEnabled:[((UITextField*)[personalTextfieldArray objectAtIndex:row])isEnabled ]];
            editTextField.frame=CGRectMake(108,6,189,31);
            if(editTextField.tag==USEREMAILTAG){
                editTextField.textColor =[UIColor grayColor];
                [editTextField setMinimumFontSize:8.0];
            }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.editingAccessoryType=UITableViewCellEditingStyleNone;
            
            break;   
        }

        case PAYMENTMETHODS:{
            CellIdentifier=@"CreditCardCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreditCardCell" owner:self options:nil];
                if ([nib count] > 0) { 
                    cell = self.ccTableViewCell;
                } else {
                    NSLog(@"failed to load MessageCell nib!");
                } 
            }
            
             //Card info
            UILabel *cardInfoLabel = (UILabel *)[cell viewWithTag:10];
            
                if ([((CreditCard*)[self.currentArray objectAtIndex:row]).cardNumber length]>14) {
                    cardInfoLabel.text = [NSString stringWithFormat:@"%@",((CreditCard*)[self.currentArray objectAtIndex:row]).cardNumber ] ;
                    //cardInfoLabel.text = [NSString stringWithFormat:@"%@",[((CreditCard*)[self.currentArray objectAtIndex:row]).cardNumber substringFromIndex:12] ] 
                }
                else{
                cardInfoLabel.text =@"Credit Card Info";
                }
            
            //Card Name
            UILabel *cardNameLabel = (UILabel *)[cell viewWithTag:20];
            cardNameLabel.text = [NSString stringWithFormat:@"%@ %@", ((CreditCard*)[self.currentArray objectAtIndex:row]).cardFirstName,((CreditCard*)[self.currentArray objectAtIndex:row]).cardLastName ];
            
            //Expiration
            UILabel *cardExpLabel = (UILabel *)[cell viewWithTag:30];
            cardExpLabel.text = [NSString stringWithFormat:@"%@/%@", ((CreditCard*)[self.currentArray objectAtIndex:row]).expMonth,((CreditCard*)[self.currentArray objectAtIndex:row]).expYear ];
            //type image
            UIImageView *ccimage = (UIImageView*)[cell viewWithTag:60];
            ccimage.image=[cclogos objectForKey:((CreditCard*)[self.currentArray objectAtIndex:row]).ccType];
            
            
            //Primary Image
             UIImageView *primaryCCImg = (UIImageView*)[cell viewWithTag:70];
            if(((CreditCard*)[self.currentArray objectAtIndex:row]).isPrimary)
                primaryCCImg.image=[UIImage imageNamed:@"PrimaryPaymentBoxChecked.png"];
            else {
                primaryCCImg.image=[UIImage imageNamed:@"PrimaryPaymentBoxUnchecked.png"];

            }
            
            
            break;   
        }
            
        case ADDRESSBOOK:{
            
            CellIdentifier=@"AddressCellIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            
                       
            //nameLabel
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:10];
            nameLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[self.currentArray objectAtIndex:row]).toName ];

            //Address Label
            UILabel *addressLabel = (UILabel *)[cell viewWithTag:20];
            addressLabel.text = [NSString stringWithFormat:@"%@", ((Address*)[self.currentArray objectAtIndex:row]).address1 ];
            
            //Address Label
            UILabel *cityStateZipLabel = (UILabel *)[cell viewWithTag:30];
            cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", 
                                      ((Address*)[self.currentArray objectAtIndex:row]).city,
                                      ((Address*)[self.currentArray objectAtIndex:row]).state,
                                      ((Address*)[self.currentArray objectAtIndex:row]).zip ];
            //Primary Image
             UIImageView *primaryAddImg = (UIImageView*)[cell viewWithTag:70];
            if(((Address*)[self.currentArray objectAtIndex:row]).primary)
                primaryAddImg.image=[UIImage imageNamed:@"PrimaryShipAddressCheckbox.png"];
            else {
                primaryAddImg.image=[UIImage imageNamed:@"PrimaryShipAddressUnchecked.png"];
                
            }
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.editingAccessoryType=UITableViewCellEditingStyleNone;
            
            break;
        }
            
        case CHANGEPASSWORD:{
            CellIdentifier=@"editCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditCell" owner:self options:nil];
                if ([nib count] > 0) 
                    cell = self.editTableViewCell;
                else 
                    NSLog(@"failed to load MessageCell nib!");
            }
            //Card info
            UILabel *passwordCellLabel = (UILabel *)[cell viewWithTag:40];
            passwordCellLabel.text = [currentArray objectAtIndex:row];
            //create the password text fields and set the textfield tag based on the row in the tableview
            UITextField *passwordTextField = (UITextField*)[cell viewWithTag:50];
            [passwordTextField setTag:((UITextField*)[passwordTextFieldArray objectAtIndex:row]).tag] ;
            [passwordTextField setSecureTextEntry:YES];
            passwordTextField.clearButtonMode= UITextFieldViewModeWhileEditing;
            passwordTextField.clearsOnBeginEditing=YES;
            passwordTextField.frame=CGRectMake(140,6,150,31);

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            break;   
        }
        default:
            NSLog(@"Ooops!, something is wrong");
            break;
            
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && tableView ==accountDetailTableView ) {
        rowforDeletion = [indexPath row];
        [confirmDelete show];
        }   
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editItemViewController = [[EditItemViewController alloc] init];
    switch (self.accountOption) {
        case PAYMENTMETHODS:
            editItemViewController.accountOption=EDITCC;
            editItemViewController.currentCreditCard=[self.currentArray objectAtIndex:[indexPath row]];
            [self.navigationController pushViewController:editItemViewController animated:YES];

            break;
        case ADDRESSBOOK:
              editItemViewController.accountOption=EDITADDRESS;
            editItemViewController.currentAddress=[self.currentArray objectAtIndex:[indexPath row]];
            [self.navigationController pushViewController:editItemViewController animated:YES];

            break;
        case CHANGEPASSWORD:
           
            break;
        default:
            break;
    }
   }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.accountOption) {
        case PERSONALSETTINGS:
            case CHANGEPASSWORD:
            return 44.0;
            break;
        case PAYMENTMETHODS:
            return 76.0;
            break;
        case ADDRESSBOOK:
            return 82;
            break;  
        default:
            break;
    }
    return 90.0;
}
#pragma AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
    if(alertView ==confirmDelete){
        switch (buttonIndex) {
            case 0:break;
            case 1:{
                if (accountOption==PAYMENTMETHODS) {
                    
                    if([appDel removeCreditCard:[currentArray objectAtIndex:rowforDeletion]]){
                        self.currentArray=appDel.wallet;
                        if([self.currentArray count]==0)
                            [self.navigationController popViewControllerAnimated:YES];
                        else
                            [accountDetailTableView reloadData];
                        
                    }
                }
                if (accountOption==ADDRESSBOOK) {
                    
                    if([appDel removeAddress:[currentArray objectAtIndex:rowforDeletion]]){
                        
                        self.currentArray=appDel.addressBook;
                        if([self.currentArray count]==0)
                            [self.navigationController popViewControllerAnimated:YES];
                        else
                            [accountDetailTableView reloadData];
                    }
                }

                    }
                break;
            default:
                break;
        }
                
    }
    else{
        
    
    switch(buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self newItem:nil];
            break;
        default:
            break;
    }
    }
}

#pragma mark - New Items Function
-(IBAction)newItem:(id)sender{
    editItemViewController = [[EditItemViewController alloc] init];
    if (accountOption == PAYMENTMETHODS) 
        editItemViewController.accountOption=NEWCC;
    if (accountOption ==ADDRESSBOOK) 
        editItemViewController.accountOption=NEWADDRESS;

    [self.navigationController pushViewController:editItemViewController animated:YES];
   }



-(IBAction)savePersonalInfo:(id)sender{
    [self.view endEditing:YES];

//validation
    //FirstName
    if([userFName.text isEqual:@""]){
        userFName.text= [appDel.accountInfo objectForKey:@"fName"];
    }
    [appDel updatePersonalInfoToServer:userFName.text andLastname:userLName.text];

    [self .navigationController popViewControllerAnimated:YES];
}

-(IBAction)updatePass:(id)sender{

    [self.view endEditing:YES];
     
    NSString *error=[[NSString alloc]init];
    Validator *validator = [[Validator alloc]init];
    error=[validator checkThisOldPassword:currentPass.text currentPassword:[appDel.keychain objectForKey:(__bridge id)kSecValueData] newPassword:nPass.text andRetypedPass:nPass2.text];
    
       if ([error length]>0) {
        [appDel displayErrorMsgToUserWithTitle:error andMsg:@""];
        }
       else{
           [appDel updateNewPasswordToServer:nPass.text andConfirmPassword:nPass2.text andOldPassword:currentPass.text];
            [self.navigationController popViewControllerAnimated:YES];
       }
      }


#pragma Mark - textfield delegate
// Textfield value changed, store the new value.  
- (void)textFieldDidEndEditing:(UITextField *)textField {  

    if([textField.text  isEqualToString:@""]){
        textField.text = currentTextString;
        currentTextString=@"";
    }
    switch (textField.tag) {
        case CURRENTPASSTAG:currentPass.text =  textField.text;break;
        case NPASSTAG:nPass.text =              textField.text;break;
        case NPASS2TAG:nPass2.text =            textField.text;break;
        case USERFNAMETAG:userFName.text =      [textField.text isEqual:@""]?[appDel.accountInfo objectForKey:@"fName"]:textField.text;
            break;
        case USERLNAMETAG:userLName.text =      [textField.text isEqual:@""]?[appDel.accountInfo objectForKey:@"lName"]:textField.text;
            break;

        case USEREMAILTAG:userEmail.text =      textField.text;break;
        default:break;
    } 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    switch(textField.tag){
        case USERFNAMETAG:currentTextString=userFName.text; break;
        case USERLNAMETAG:currentTextString=userLName.text; break;
    }

        
}
-(IBAction)backgroundTap:(id)sender{
 
    
    [userFName      resignFirstResponder];
    [userLName      resignFirstResponder];
    [currentPass    resignFirstResponder];
    [nPass2         resignFirstResponder];
    [nPass          resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
       [appDel.accountInfo objectForKey:@"fName"];
       
    if([textField isEqual:userLName]&& [userLName.text isEqual:@""])
        [appDel.accountInfo objectForKey:@"lName"];
    
    [textField resignFirstResponder];
    return YES;
}
@end
