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

@synthesize accountOption;
@synthesize cclogos;
@synthesize currentPass,
            nPass,
            nPass2,
            userFName,
            userLName,
            userEmail;

@synthesize appDel;
@synthesize accountDetailTableView;
@synthesize ccTableViewCell,addressTableViewCell,editTableViewCell;
@synthesize editPassAlert;
@synthesize editItemViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
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
 
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newItem:)];
    [newButton setTintColor:[UIColor blueColor]];
    
    

  // load in cc logos
    cclogos = [[NSMutableDictionary alloc] init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"discover_logo" ofType:@"jpg"] ;
    UIImage *Logo = [[UIImage alloc] initWithContentsOfFile:path];
    [cclogos setValue:Logo forKey:@"Discover"];
    
   path = [[NSBundle mainBundle]pathForResource:@"visaLogo" ofType:@"gif"] ;
   Logo = [[UIImage alloc] initWithContentsOfFile:path];
    [cclogos setValue:Logo forKey:@"Visa"]; 
    
    path = [[NSBundle mainBundle]pathForResource:@"MClogo" ofType:@"gif"] ;
    Logo = [[UIImage alloc] initWithContentsOfFile:path];
    [cclogos setValue:Logo forKey:@"MasterCard"]; 
    
    
    switch ((NSInteger ) accountOption)
    
    {
        case PERSONALSETTINGS:{
        
            
            self.title = @"Personal Settings";
            self.userFName.text = [appDel.accountInfo objectForKey:@"fName"];
            self.userLName.text = [appDel.accountInfo objectForKey:@"lName"];
        
            //Setup for Personal Info arrays
            personalLabelArray=[[NSArray alloc] initWithObjects:@"First Name",@"Last Name",@"Current Email", nil];
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
            personalLabelArray = [[NSArray alloc]initWithObjects:@"First Name",@"Last Name",@"Current Email", nil];
            
            //Save personal Info Button
            UIBarButtonItem *savePersonalInfoButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePersonalInfo:)];
            [savePersonalInfoButton setTintColor:[UIColor blueColor]];
            self.currentArray=personalLabelArray;

            self.navigationItem.rightBarButtonItem=savePersonalInfoButton;
            break;
        }
        case CHANGEPASSWORD:{
            self.title = @"Change Password";
            //Setup for Password view arrays 
            
            currentPass=[[UITextField alloc]init] ;
            [currentPass setTag:CURRENTPASSTAG];
            [currentPass setPlaceholder:@""];
            
            nPass=[[UITextField alloc]init] ;
            [nPass setTag:NPASSTAG];
            
            nPass2=[[UITextField alloc]init] ;
            [nPass2 setTag:NPASS2TAG];
            
            passwordTextFieldArray=[[NSArray alloc] initWithObjects:currentPass ,nPass,nPass2,nil];
            passwordLabelArray=[[NSArray alloc] initWithObjects:@"Current Password",@"New Password",@"Retype Password", nil];
            
            ////  
            
            //Save Password Button
            UIBarButtonItem *upDatePassButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updatePass:)];
            [upDatePassButton setTintColor:[UIColor blueColor]];
            
            self.currentArray=passwordLabelArray;
            self.navigationItem.rightBarButtonItem=upDatePassButton;
            break;
        }
        case PAYMENTMETHODS:{
            self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] wallet];
           self.title =@"Payment Methods";
           
            
                self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] wallet];
                self.navigationItem.rightBarButtonItem=newButton;
              
                    
            break;   
        }
        case ADDRESSBOOK:{
            self.title=@"My addressbook";
         
            self.currentArray = [(AppDelegate*)[[UIApplication sharedApplication]delegate] addressBook];
            self.navigationItem.rightBarButtonItem=newButton;
            break;

        }
        default:
                        break;
            
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.currentArray = nil;
    self.accountDetailTableView = nil;
    self.editTableViewCell=nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.accountDetailTableView reloadData];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if([[self class] isEqual:[AccountDetailViewController class]]){
    NSString *noEntriesTtl;
    NSString *noEntriesMsg=[NSString stringWithFormat:@"%@",@"Would you like to create a new one?"];
    
    
   
    if([currentArray count]==0){
        if(accountOption==PAYMENTMETHODS){
            noEntriesTtl=[NSString stringWithFormat:@"%@",@"So Yeahhh ....ummm... you dont have any credit cards"];
            
        }
        else if(accountOption==ADDRESSBOOK){
            noEntriesTtl=[NSString stringWithFormat:@"%@",@"So Yeahhh....  uhh... you dont have any addresses"];
        }  
    
        UIAlertView *emptyArrayAlert = [[UIAlertView alloc]initWithTitle:noEntriesTtl message:noEntriesMsg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [emptyArrayAlert show];
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
            editCellLabel.font= [UIFont fontWithName:@"" size:15.0];
            editCellLabel.frame=CGRectMake(30.0, 20.0, 125.0, 20.0);
            
            //create the password text fields and set the textfield tag based on the row in the tableview
            
            UITextField *editTextField = (UITextField*)[cell viewWithTag:50];
            [editTextField setTag:((UITextField*)[personalTextfieldArray objectAtIndex:row]).tag];
             [editTextField setText:((UITextField*)[personalTextfieldArray objectAtIndex:row]).text];
            [editTextField setEnabled:[((UITextField*)[personalTextfieldArray objectAtIndex:row])isEnabled ]];
            editTextField.frame=CGRectMake(150.0, 10.0, 145.0, 38.0);
            if(editTextField.tag==USEREMAILTAG){
                editTextField.textColor =[UIColor grayColor];
               
                [editTextField setMinimumFontSize:9.0];
            }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
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
                    cardInfoLabel.text = [NSString stringWithFormat:@"%@ ending %@", ((CreditCard*)[self.currentArray objectAtIndex:row]).ccType,[((CreditCard*)[self.currentArray objectAtIndex:row]).cardNumber substringFromIndex:12] ] ;
                }
                else{
                cardInfoLabel.text =@"cc info";
                }
            
            //Card Name
            UILabel *cardNameLabel = (UILabel *)[cell viewWithTag:20];
            cardNameLabel.text = [NSString stringWithFormat:@"%@ %@", ((CreditCard*)[self.currentArray objectAtIndex:row]).cardFirstName,((CreditCard*)[self.currentArray objectAtIndex:row]).cardLastName ];
            
            //Expiration
            UILabel *cardExpLabel = (UILabel *)[cell viewWithTag:30];
            cardExpLabel.text = [NSString stringWithFormat:@"%@/%@", ((CreditCard*)[self.currentArray objectAtIndex:row]).expMonth,((CreditCard*)[self.currentArray objectAtIndex:row]).expYear ];
            
            UIImageView *ccimage = (UIImageView*)[cell viewWithTag:60];
            
            ccimage.image=[cclogos objectForKey:((CreditCard*)[self.currentArray objectAtIndex:row]).ccType];
            
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
            
            
            if (((Address*)[self.currentArray objectAtIndex:row]).primary) 
                    cell.accessoryType=UITableViewCellAccessoryCheckmark;                  
            else
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
            
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
            passwordCellLabel.font= [UIFont fontWithName:@"" size:15.0];
            passwordCellLabel.frame=CGRectMake(15.0, 15.0, 150.0, 25.0);
            
            //create the password text fields and set the textfield tag based on the row in the tableview
            UITextField *passwordTextField = (UITextField*)[cell viewWithTag:50];
            [passwordTextField setTag:((UITextField*)[passwordTextFieldArray objectAtIndex:row]).tag] ;
            [passwordTextField setPlaceholder:[passwordLabelArray objectAtIndex:row]];
            
            passwordTextField.frame=CGRectMake(165.0, 10.0, 128.0, 38.0);
            [passwordTextField setSecureTextEntry:YES];
            passwordTextField.clearButtonMode= UITextFieldViewModeWhileEditing;
            passwordTextField.clearsOnBeginEditing=YES;
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
          
        if (accountOption==PAYMENTMETHODS) {
        
            if([appDel removeCreditCard:[currentArray objectAtIndex:[indexPath row]]]){
                self.currentArray=appDel.wallet;
                [tableView reloadData];
                
            }
 
            
                       
        }
        if (accountOption==ADDRESSBOOK) {
            
            if([appDel removeAddress:[currentArray objectAtIndex:[indexPath row]]]){
                
                self.currentArray=appDel.addressBook;
                [tableView reloadData];

            }
        }
       
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
            return 60.0;
            break;
        case PAYMENTMETHODS:
            return 80.0;
            break;
        case ADDRESSBOOK:
            return 75;
            break;  
        case CHANGEPASSWORD:
            return 50.0;
            break;   
        default:
            break;
    }
    return 90.0;
}
#pragma AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
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

#pragma mark - New Items Function
-(IBAction)newItem:(id)sender{
    
    editItemViewController = [[EditItemViewController alloc] init];
   
    if (accountOption == PAYMENTMETHODS) 
        editItemViewController.accountOption=NEWCC;
    
    if (accountOption ==ADDRESSBOOK) 
        editItemViewController.accountOption=NEWADDRESS;

    [self.navigationController pushViewController:editItemViewController animated:YES];
   
    /*
    if([currentArray count]==0){
        //remove current viewcontroller so when the user click the back button the account options view is displayed
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo: self];
        self.navigationController.viewControllers = allViewControllers;
        
    }
     */
    }



-(IBAction)savePersonalInfo:(id)sender{

    [self.view endEditing:YES];
    
 
   
//validation
    //FirstName
    if([userFName.text isEqual:@""]){
        userFName.text= [appDel.accountInfo objectForKey:@"fName"];
    }
    

    if([appDel updatePersonalInfoToServer:userFName.text andLastname:userLName.text]){
        [appDel displayErrorMsgToUserWithTitle:@"Update Success" andMsg:@"Personal info Successfully updated"];
       
    }
    else{   
        [appDel displayErrorMsgToUserWithTitle:@"Update Problem" andMsg:@"Something went wrong when updating your personal info"];
    }
    
    [self .navigationController popViewControllerAnimated:YES];
}

-(IBAction)updatePass:(id)sender{
   
    
    [self.view endEditing:YES];
     
    NSString *error=[[NSString alloc]init];
    
    //check that the password entered matches the stored password.
    if ([[appDel.keychain objectForKey:(__bridge id)kSecValueData]isEqual:currentPass.text]) {
        
        
        //check the new password and the confirmation are equal
        if ([nPass.text isEqual:nPass2.text]) {
            //check that the old password and the new password are not the s
            if ([[appDel.keychain objectForKey:(__bridge id)kSecValueData]isEqual:nPass.text]) 
                error=@"Your new password is the same as your old password.";    
            
            //check that the new passwords fit validation requirements
            if ((![nPass.text length]<3&&[nPass.text length]>8))
                    error=@"New password needs to between 3 and 8 characters";
              
        }
        else{
            error=@"New passwords do not match" ;     
        }
    }
    else{
            error=@"Current password does not match";
        }
       if ([error length]>0) {
        [appDel displayErrorMsgToUserWithTitle:error andMsg:@""];
        }
    else if ([appDel updatePasswordToServer:nPass2.text]){
         [appDel displayErrorMsgToUserWithTitle:@"Success" andMsg:@"Password Successfully Changed"];
         [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"New password %@",[appDel.keychain objectForKey:(__bridge id)kSecValueData]);
     }
     else
         [appDel displayErrorMsgToUserWithTitle:@"Error" andMsg:@"There was a Problem updating you password to the server"];  
    
}


#pragma Mark - textfield delegate
// Textfield value changed, store the new value.  
- (void)textFieldDidEndEditing:(UITextField *)textField {  

    
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
-(IBAction)backgroundTap:(id)sender{
 
    
    [userFName      resignFirstResponder];
    [userLName      resignFirstResponder];
    [currentPass    resignFirstResponder];
    [nPass2         resignFirstResponder];
    [nPass          resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // if([textField isEqual:userFName])&& [userFName.text isEqualToString:@""])
       [appDel.accountInfo objectForKey:@"fName"];
       
    if([textField isEqual:userLName]&& [userLName.text isEqual:@""])
        [appDel.accountInfo objectForKey:@"lName"];
    
    [textField resignFirstResponder];
    return YES;
}
@end
