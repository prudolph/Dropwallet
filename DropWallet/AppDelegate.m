//
//  AppDelegate.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "AppDelegate.h"

#import "RootActivityViewController.h"
#import "RootAccountViewController.h"
#import "RootHelpViewController.h"
#import "LogInViewController.h"
#import "Address.h"
#import "CreditCard.h"

@implementation AppDelegate

@synthesize window;

@synthesize tabBarController;

@synthesize rootActivityViewController,
            rootAccountViewController,
            rootHelpViewController;

@synthesize activityNavigationController,
            accountNavigationController,
            helpNavigationController;

//User data Arrays
@synthesize addressBook,
            wallet,
            orders,
            accountInfo,appText,imageCache;

//keychain
@synthesize keychain;
//json Parser
@synthesize jsonParser,jsonWriter;
@synthesize hostReach;
@synthesize generalAlert;
@synthesize loadIndicator;
@synthesize orderPages,orderCurrentPage,walletPages,walletCurrentPage,addressPages,addressCurrentPage;
@synthesize logoImgView,titleLabelView;
@synthesize saveInfoBOOl,stayLoggedIn,SYSdemo;



static const NSString * AUTHHEADER= @"ZHJvcHdhbGxldDppY3VldHY3ODk=";
static const bool AUTHTYPE=YES;

//static const NSString * DROPWALLETURL = @"http://10.0.1.152:8080/core/restful/";//staging
//static const NSString * DROPWALLETURL = @"http://api.stage0.dropwallet.int/";//staging endpoint
static const NSString * DROPWALLETURL = @"https://api.dropwallet.net/";//prod


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    //Bool and orderpages
    saveInfoBOOl = NO;
    stayLoggedIn = NO;

    SYSdemo =YES;
    NSLog(@"DID FINISH LAUNCHING DEMO MODE: %s", SYSdemo?"ON":"OFF");
  
    orderPages,orderCurrentPage,walletPages,walletCurrentPage,addressPages,addressCurrentPage=0;
    
    //load text files
    appText= [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"]]; 


    //loadSmallLogo to be used through out the application
    logoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DropWalletLogoSmall.png"]];
    logoImgView.frame=CGRectMake(130.0, 5.0, 55.0, 29.0);
    
    titleLabelView = [[UILabel alloc]init];
    titleLabelView.textColor = [UIColor lightGrayColor];
    
    //load indicator
    loadIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadIndicator.color=[UIColor colorWithRed:0.0 green:151.9f/255.0f blue:185.0f/255.0f alpha:1.0];
    
    //Load generalalert
    generalAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    

    // Initalize userData
    self.accountInfo=   [[NSMutableDictionary alloc]init];
    self.imageCache =   [[NSMutableDictionary alloc]init];
    self.addressBook =  [[NSMutableArray alloc] init];
    self.wallet =       [[NSMutableArray alloc] init];
    self.orders =       [[NSMutableArray alloc] init];
    
    
    
    //Setup keychain wrapper
	keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"mainLogin" accessGroup:nil];
    [keychain resetKeychainItem];

    
    //load json parser
    jsonParser = [[SBJsonParser alloc]init];
    jsonWriter=[[SBJsonWriter alloc]init];
    
  
     // set up naviation hierarchy
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
   
    //rootviewcontrollers
    self.rootActivityViewController =[[RootActivityViewController alloc] initWithNibName:@"RootActivityViewController" bundle:nil];    
    self.rootAccountViewController = [[RootAccountViewController alloc]  initWithNibName:@"RootAccountViewController"  bundle:nil];
    self.rootHelpViewController =    [[RootHelpViewController alloc]     initWithNibName:@"RootHelpViewController"     bundle:nil];
        
    //Call init to ensure the titles are set to the tab bar buttons
    [self.rootAccountViewController init];
    [self.rootAccountViewController init];
    [self.rootHelpViewController init];

//Set up Navigation Controllers
    //Acitivity Navigation controller 
    self.activityNavigationController = [[UINavigationController alloc]initWithRootViewController:self.rootActivityViewController];
    self.activityNavigationController.tabBarItem.image=[UIImage imageNamed:@"ActivityIcon.png"];
    [self.activityNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"leathernavimage.png"] forBarMetrics:UIBarMetricsDefault];    
    [self.activityNavigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    
    //Account -Navigation controller
    self.accountNavigationController = [[UINavigationController alloc]initWithRootViewController:self.rootAccountViewController];
    self.accountNavigationController.tabBarItem.image=[UIImage imageNamed:@"AccountIcon.png"];
    [self.accountNavigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.accountNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"leathernavimage.png"] forBarMetrics:UIBarMetricsDefault];  


    //Help Navigation controller
    self.helpNavigationController= [[UINavigationController alloc]initWithRootViewController:self.rootHelpViewController];
    self.helpNavigationController.tabBarItem.image=[UIImage imageNamed:@"HelpIcon.png"];
    [self.helpNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"leathernavimage.png"] forBarMetrics:UIBarMetricsDefault];    
    [self.helpNavigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
   
    
    //Add view controllers to Tab barController
   self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.activityNavigationController, self.accountNavigationController,self.helpNavigationController, nil];
   // self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.helpNavigationController, nil];
    
    self.tabBarController.tabBar.backgroundImage =[UIImage imageNamed:@"TabButtonBGImageBlack.png"] ;

    self.window.rootViewController = self.tabBarController;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
   
     
    // check for user credentials
    //if the keychain is empty or the credentials are invalid
     if (([[keychain objectForKey:(__bridge  id)kSecValueData] isEqual:@""]) || 
        ([[keychain objectForKey:(__bridge id)kSecAttrAccount] isEqual:@""])) {

         LogInViewController *loginViewController = [[LogInViewController alloc] init];
   [self.tabBarController presentModalViewController:loginViewController animated:NO];
         
    }
return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
     //Refresh users data
    if([accountInfo objectForKey:@"userId"] ){
        if(![[accountInfo objectForKey:@"userId"] isEqualToString:@""]){
            orderCurrentPage=0;
            [self loadOrders];
            [self matchItemstoPictures];
            [self loadWallet];
            [self loadAddressBook];
            [rootActivityViewController.purchasesTableView reloadData];
        }
    }
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [imageCache removeAllObjects];
   }
#pragma Mark - Retrive Data
#pragma Mark -SERVER FUNCTIONS
-(void)checkCredentials{
    NSString *loginString = [NSString stringWithFormat:@"username=%@&password=%@",
                             [keychain objectForKey:(__bridge id)kSecAttrAccount] ,
                             [keychain objectForKey:(__bridge  id)kSecValueData]];
    
    if(SYSdemo){
        NSLog(@"DEMO: Skipping Credential Check");
        NSDictionary *demoLoginDict=[NSDictionary dictionaryWithObjectsAndKeys:@"0000",@"userId",
                                     @"SUCCESS",@"status",
                                     @"Sample",@"firstName",
                                     @"User",@"lastName",
                                     nil];
        
             [self didReciveData:[[jsonWriter stringWithObject:demoLoginDict]dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
    [self sendHttpRequestWithType:@"POST"
                          andBody:[loginString dataUsingEncoding:NSUTF8StringEncoding] 
                            toURL:[NSString stringWithFormat:@"session/login"]];
    }
}

-(void)updatePersonalInfoToServer:(NSString*)fname
                         andLastname:(NSString*)lname{
    NSString* body =[NSString stringWithFormat:@"firstName=%@&lastName=%@",fname,lname];
    [self sendHttpRequestWithType:@"PUT" 
                          andBody:[body dataUsingEncoding:NSUTF8StringEncoding]  
                            toURL:[NSString stringWithFormat:@"users/%@",[accountInfo objectForKey:@"userId"]]];
    
}

-(void)updateNewPasswordToServer:(NSString*)newPass 
               andConfirmPassword: (NSString*)confrimPass
                  andOldPassword:(NSString*)oldPass
{
    NSString *passwordString=[NSString stringWithFormat:@"currentPassword=%@&newPassword=%@&confirmPassword=%@",oldPass,newPass,confrimPass];
    [self sendHttpRequestWithType:@"PUT" 
                          andBody:[passwordString dataUsingEncoding:NSUTF8StringEncoding] 
                            toURL:[NSString stringWithFormat:@"users/%@",[accountInfo objectForKey:@"userId"]]];
}

//Address
-(BOOL)updateModifiedAddressToServer:(Address *)modifiedAddress{
  [self sendHttpRequestWithType:@"PUT" 
                        andBody:[modifiedAddress asDataForUpdate] 
                          toURL:[NSString stringWithFormat:@"users/%@/postaladdresses/%@",[accountInfo objectForKey:@"userId"],modifiedAddress.addressID]];
}

-(BOOL)updateNewAddressToServer:(Address *)newAddress{
     //Check if the Address already exists in the addressbook
    for(Address* a in addressBook){
        if ([a addressIsEqualto:newAddress]) {
            [self displayErrorMsgToUserWithTitle:[appText objectForKey:@"Dup_Address-Title"] andMsg:[appText objectForKey:@"Dup_Address-Msg"]];
            return NO;
        }
    }
    
     [self sendHttpRequestWithType:@"POST" andBody:[newAddress asDataForUpdate] toURL:[NSString stringWithFormat:@"users/%@/postaladdresses",[accountInfo objectForKey:@"userId"]]];
    return YES;
}    



-(BOOL)removeAddress:(Address*)addressToBeRemoved{
    NSData *responseData=  [self deleteFromURL:[NSString stringWithFormat:@"users/%@/postaladdresses/%@",[accountInfo objectForKey:@"userId"],addressToBeRemoved.addressID]];
   
    if ([[jsonParser objectWithData:responseData ] isKindOfClass:[NSDictionary class]]){
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:[jsonParser objectWithData:responseData ]];
                return NO;
    
    }
    else {
    [addressBook removeObject:addressToBeRemoved];   
        return YES;
    }
}


-(BOOL)updateModifiedCreditCardToServer:(CreditCard *)modifiedCreditCard{

    //check if the modified Credit card's billing address is equal to a address in the addressbook, if it is set the billing address id to the address id so the server wont create a new address
    for (Address *a in addressBook){
        if([a addressIsEqualto: modifiedCreditCard.billingAddress])
                modifiedCreditCard.billingAddress.addressID=a.addressID;        
    }

    [self sendHttpRequestWithType:@"PUT" 
                          andBody:[modifiedCreditCard asDataForUpdate:YES]  
                            toURL:[NSString stringWithFormat:@"users/%@/paymentmethods/%@",[accountInfo objectForKey:@"userId"],
                                                                                              modifiedCreditCard.paymentID]];
    }

-(void)UpdateNewCreditCardToServer:(CreditCard *)newCreditCard{
    //check if the modified Credit card's billing address is equal to a address in the addressbook, if it is set the billing address id to the address id so the server wont create a new address
    for (Address *a in addressBook){
        if([a addressIsEqualto: newCreditCard.billingAddress])
            newCreditCard.billingAddress.addressID=a.addressID;        
    }
    [self sendHttpRequestWithType:@"POST" 
                          andBody:[newCreditCard asDataForUpdate:NO]  
                            toURL:[NSString stringWithFormat:@"users/%@/paymentmethods",[accountInfo objectForKey:@"userId"]]];
    
}
-(BOOL)removeCreditCard:(CreditCard*)creditCardToBeRemoved{
    NSData *responseData=  [self deleteFromURL:[NSString stringWithFormat:@"users/%@/paymentmethods/%@",[accountInfo objectForKey:@"userId"],creditCardToBeRemoved.paymentID]];
        if ([[jsonParser objectWithData:responseData ] isKindOfClass:[NSDictionary class]]){
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:[jsonParser objectWithData:responseData ]];
            
            if([responseDict count]==0){
                for(CreditCard  *c in wallet){
                    if([c.paymentID isEqual:creditCardToBeRemoved.paymentID]){
                        [wallet  removeObject:c];break;
                    }    
                }
            }
        }
    return YES;
}


-(void)loadAddressBook{
    if(!addressBook)
        addressBook=[[NSMutableArray alloc]init];
    if(SYSdemo){
        NSLog(@"DEMO: LOADING AddressBook");
    }
    else{
    [self sendHttpRequestWithType:@"GET" 
                          andBody:nil 
                            toURL:[NSString stringWithFormat:@"users/%@/postaladdresses",[accountInfo objectForKey:@"userId"]]];
    }
}

-(void)loadWallet{
    if(!wallet)
        wallet=[[NSMutableArray alloc]init];
    
    if(SYSdemo){
        NSLog(@"DEMO: LOADING Wallet");
    }
    else{
    [self sendHttpRequestWithType:@"GET"
                          andBody:nil 
                            toURL:[NSString stringWithFormat:@"users/%@/paymentmethods",[accountInfo objectForKey:@"userId"]]];
    }
}

-(void)loadOrders{
    if(!orders)
        orders=[[NSMutableArray alloc]init];
    
    if(SYSdemo){
        NSLog(@"DEMO: LOADING ORDERS");
        
              NSString *sampleOrderData = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orderTestData1" ofType:@"txt"]
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
        
        NSLog(@"Sample Data %@", sampleOrderData);
         
               //////
        /*
            NSDictionary *demoOrdersDict=[NSDictionary dictionaryWithObjectsAndKeys:@"0000",@"userId",
                                     @"SUCCESS",@"status",
                                     @"Sample",@"firstName",
                                     @"User",@"lastName",
                                     nil];
        
        [self didReciveData:[[jsonWriter stringWithObject:demoOrdersDict]dataUsingEncoding:NSUTF8StringEncoding]];
         */
        //////
    }
    else{
       [self sendHttpRequestWithType:@"GET"
                              andBody:nil 
                                 toURL:[NSString stringWithFormat:@"users/%@/orders?page=%d",[accountInfo objectForKey:@"userId"],orderCurrentPage]];
        }

   }
-(void)getSpecificOrder:(Order *)orderToUpdate{
    //check if more data is needed for particular order
    if(!orderToUpdate.individuallyUpdated){
        [self sendHttpRequestWithType:@"GET" 
                              andBody:nil 
                                toURL:[NSString stringWithFormat:@"users/%@/orders/%@",[accountInfo objectForKey:@"userId"],orderToUpdate.orderNumber]];   
    }
}
-(void)cancelOrder:(NSString*) orderNumber{
    
    //Switch this back
    [self sendHttpRequestWithType:@"PUT" andBody:nil toURL:[NSString stringWithFormat:@"users/%@/orders/%@/cancel",[accountInfo objectForKey:@"userId"],orderNumber]];
        
}
-(void)loadImages{
    for(int i =0;i<[imageCache count];i++){
         if(![[imageCache objectForKey:[[imageCache allKeys]objectAtIndex:i]] isKindOfClass:[UIImage class]] )
            [self getImageSyncFromURL:[NSString stringWithFormat:@"%@",[[imageCache allKeys]objectAtIndex:i]]];
    }
    [self matchItemstoPictures];
}


#pragma Mark - NSURLCONNECTION
-(BOOL)testConnection{
     //Reachability* DWReach = [Reachability reachabilityWithHostname:@"http://api.stage0.dropwallet.int/"];
    Reachability* wifiReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus wifiStatus = [wifiReach currentReachabilityStatus];
     if(wifiStatus==0)return NO;
    else return YES;
}

//General http request

-(void)sendHttpRequestWithType:(NSString*)type andBody:(NSData *)body toURL:(NSString *)urlSuffix{
    if(![self testConnection]){
        [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"No_Conn-Title"] andMsg:[self.appText objectForKey:@"No_Conn-Msg"]];
        return;
    }
    
    NSLog(@"%@ %@",type,[NSString stringWithFormat:@"%@%@",DROPWALLETURL,urlSuffix]);
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DROPWALLETURL,urlSuffix]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
	[request setURL:URL];
	[request setHTTPMethod:type];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(AUTHTYPE)
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authorization"];
    else 
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authentication"];
    
    [request setHTTPBody:body]; 
    
    NSLog(@"request headers %@", [request allHTTPHeaderFields]);
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
             [self didReciveData:data];
         else if(error){
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"%@",error);
                 [loadIndicator stopAnimating];
                 [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"Gen_Conn_Fail-Title"] andMsg:[self.appText objectForKey:@"Gen_Conn_Fail-Msg"]];                    
             });
         }}];
}

-(NSData *)deleteFromURL:(NSString *)urlSuffix{

    if(![self testConnection]){
        [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"No_Conn-Title"] andMsg:[self.appText objectForKey:@"No_Conn-Msg"]];
        
        return nil;
    }
    
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",DROPWALLETURL,urlSuffix]);
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DROPWALLETURL,urlSuffix]];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
	NSHTTPURLResponse *response = nil;
	NSError *error;
    
	[request setURL:URL];
	[request setHTTPMethod:@"DELETE"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(AUTHTYPE)
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authorization"];
    else 
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authentication"]; 
    NSData *returnData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  	
    if (response) {
		if ([response statusCode] >= 300)
			return nil;
		else return returnData;
	} else return nil;
}

-(void)getImageSyncFromURL:(NSString *)imageUrl {
   
if(![self testConnection]){
    [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"No_Conn-Title"] andMsg:[self.appText objectForKey:@"No_Conn-Msg"]];
    return ;
}
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",imageUrl]);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [request setURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(AUTHTYPE)
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authorization"];
    else 
        [request setValue:[NSString stringWithFormat:@"Basic %@",AUTHHEADER] forHTTPHeaderField:@"Authentication"];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
 {
     
     if ([data length] > 0 && error == nil)
         [self didReciveImageData:data from:imageUrl];
     else if(error){
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadIndicator stopAnimating];
         });
     }
      }];
}

-(void)didReciveData:(NSData*)thedata{
    NSLog(@"RECIVED DATA ");

    if ([[jsonParser objectWithData:thedata ] isKindOfClass:[NSDictionary class]]){
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:[jsonParser objectWithData:thedata ]];
        //FIRST CHECK IF THE RESPONSE IS AN ERROR
        if([[responseDict allKeys] containsObject:@"errorCode"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                //Check for the JTA MESSAGE
                
                if([[responseDict objectForKey:@"errorMessage"] rangeOfString:@"javax.transaction.RollbackException"].location != NSNotFound){
                    [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"Gen_Conn_Fail-Title"] andMsg:[self.appText objectForKey:@"Order_Detail_NoDisp-Msg"]];
                }
                else if([[responseDict objectForKey:@"errorMessage"] rangeOfString:@"cancel"].location != NSNotFound){
                    [self displayErrorMsgToUserWithTitle:@"Can't cancel order" andMsg:[responseDict objectForKey:@"errorMessage"]];
                }
                else {
                [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"Gen_Conn_Fail-Title"] andMsg:[responseDict objectForKey:@"errorMessage"]];
                }
                
                
            [self. loadIndicator stopAnimating];
            });
            NSLog(@"Error Message %@",responseDict);
        }
        else {
      NSLog(@"Response: %@",responseDict );

        //CHECK IF THE RETURNED DICTIONARY HAS ITEMS:   
            NSArray *singleOrderTemplate = [NSArray arrayWithObjects:@"paymentInformation",@"cancelable",@"orderId",@"grandTotal",
                                                                    @"shippingAddress",@"items",@"orderDate",@"shippingTotal",
                                                                    @"taxTotal",@"subTotal",@"shippingSpeed", nil];
           
            NSArray *singleOrderTemplate1 = [NSArray arrayWithObjects:@"grandTotal",@"orderDate",@"shippingTotal",
                                            @"taxTotal",@"subTotal",@"items",@"orderId", nil];
                 
            if ([[responseDict allKeys] containsObject:@"items"] && !([[responseDict allKeys]isEqualToArray:singleOrderTemplate]) && !([[responseDict allKeys]isEqualToArray:singleOrderTemplate1])){
            NSArray * items = [NSArray arrayWithArray:[responseDict objectForKey:@"items"]];
            if([items count]>0){
                  if([[((NSDictionary *)[items objectAtIndex:0]) allKeys] containsObject:@"postalName"])//if the items are addresses
                    [self recivedManyAddresses:items];
                else if([[((NSDictionary *)[items objectAtIndex:0]) allKeys] containsObject:@"cardType"])//if the items are credit cards
                    [self recivedManyCreditCards:items];
                 else if([[((NSDictionary *)[items objectAtIndex:0]) allKeys] containsObject:@"orderId"])// if the items are orders
                    [self recivedManyOrders:responseDict];
                
            }
        }
        
        
        //HANDLE DATA RETURNED FOR LOGIN
        else if([[responseDict allKeys] containsObject:@"userId"]){ //Its a login
           
            LogInViewController *loginViewcontroller=[[LogInViewController alloc]init];
              
            if(!accountInfo)
                accountInfo = [[NSMutableDictionary alloc]init];
            
            if([[responseDict objectForKey:@"status"] isEqualToString:@"SUCCESS"]){
                
                [accountInfo  setObject:[responseDict objectForKey:@"firstName"] forKey:@"fName"];
                [accountInfo  setObject:[responseDict objectForKey:@"lastName"] forKey:@"lName"];
                [accountInfo  setObject:[responseDict objectForKey:@"userId"] forKey:@"userId"];
                
               [self loadOrders];
               [self loadAddressBook];
               [self loadWallet];
              
                //Dismiss Modal View on main thread animated
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loginViewcontroller.submitButton setEnabled:YES];
                     [accountNavigationController popToRootViewControllerAnimated:NO];
                     [activityNavigationController popToRootViewControllerAnimated:NO]; 
                     [tabBarController setSelectedViewController:activityNavigationController];
                     [tabBarController dismissModalViewControllerAnimated:YES];
                     
                });
            }
            else if([[responseDict objectForKey:@"status"] isEqualToString:@"FAIL"]){
                [loginViewcontroller.submitButton setEnabled:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadIndicator stopAnimating];
                
                [loginViewcontroller.appPasswordTextfield setText:@""];
                     
                [self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"Failed_Login-Title"] andMsg:[self.appText objectForKey:@"Failed_Login-Msg"]];
                    
                });
            }
            
            
            return;
        }
        
        //HANDLE DATA RETURNED FOR ONE ADDRESS
        else if([[responseDict allKeys] containsObject:@"postalName"])
            [self recivedOneAddress:responseDict];
        
        //HANDLE DATA RETURNED FOR ONE CREDIT CARD
        else if([[responseDict allKeys] containsObject:@"cardType"]){
            [self recivedOneCreditCard:responseDict];
        }
            //HANDLE DATA RETURNED FOR ONE ORDER
          
        else if([[responseDict allKeys] isEqualToArray:singleOrderTemplate]||[[responseDict allKeys] isEqualToArray:singleOrderTemplate1]){
            [self recivedOneOrder:responseDict];
        }    
         else if([[responseDict allKeys] containsObject:@"emailAddress"]){        
             
             [accountInfo setObject:[responseDict objectForKey:@"firstName"] forKey:@"fName"];
             [accountInfo setObject:[responseDict objectForKey:@"lastName"] forKey:@"lName"];
        }
        }
        
    }
    else if([[NSString stringWithUTF8String:[thedata bytes]]intValue]==1){
        dispatch_async(dispatch_get_main_queue(), ^{
            orderCurrentPage=0;
            [self loadOrders];
            sleep(2);
            [self displayErrorMsgToUserWithTitle:@"Order Cancelled" andMsg:@""]; 
           
         
            #warning check to make sure the view controller exisits
            if([[[self.activityNavigationController viewControllers]objectAtIndex:1] isKindOfClass:[OrderDetailViewController class]]){
                NSString* currentOrderNumber=((OrderDetailViewController*)[[self.activityNavigationController viewControllers]objectAtIndex:1]).currentOrder.orderNumber;
                for(Order* o in orders){
                    if ([o.orderNumber isEqualToString:currentOrderNumber]){
                        ((OrderDetailViewController*)[[self.activityNavigationController viewControllers]objectAtIndex:1]).currentOrder=o; //set the updated order to the orderDetail view controller's current order
                        [((OrderDetailViewController*)[[self.activityNavigationController viewControllers]objectAtIndex:1]).orderTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                        
                        break;
                    }
                }
            }
            [loadIndicator stopAnimating];

        });

       
    }
    
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadIndicator stopAnimating];
            //[self displayErrorMsgToUserWithTitle:[self.appText objectForKey:@"Gen_Conn_Fail-Title"] andMsg:[self.appText objectForKey:@"Gen_Conn_Fail-Msg"]];                 
        });
        NSLog(@"SOMETHIGN went wrong with getting the data - response data is nil");
    }
    
}


-(void)recivedOneAddress:(NSDictionary*)responseDictionary{
    Address *currentAddress = [[Address alloc]initWithName:[responseDictionary objectForKey:@"postalName"]
                                                  address1:[responseDictionary objectForKey:@"address1"]
                                                  address2:[responseDictionary objectForKey:@"address2"]
                                                      city:[responseDictionary objectForKey:@"city"] 
                                                     state:[responseDictionary objectForKey:@"state"] 
                                                       zip:[responseDictionary objectForKey:@"zip"] 
                                                   primary:[[responseDictionary objectForKey:@"primary"]intValue]==0?NO:YES 
                                                    withID:[responseDictionary objectForKey:@"id"] ];
    
    
    
    
    
    // if the new address is set to primary go through the address book and set the rest to no then add the new address to the addressbook 
    
    if(currentAddress.primary){
        for(Address *a in addressBook)
            a.primary=NO;
    }
    
     for (int i =0;i<[addressBook count];i++){
        if([((Address*)[addressBook objectAtIndex:i]).addressID isEqualToString:currentAddress.addressID]){
            [addressBook removeObjectAtIndex:i];
            break;break;
        }
    }

       [addressBook addObject:currentAddress];
   
    EditItemViewController * editItemViewController = [[EditItemViewController alloc]init ];
     
    dispatch_async(dispatch_get_main_queue(), ^{
        [accountNavigationController popViewControllerAnimated:YES];
        [editItemViewController addressResponse]; 
    });

  
    
}
-(void)recivedManyAddresses:(NSArray*)items{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    
    for(NSDictionary* a in items){
        Address *currentAddress = [[Address alloc]initWithName:[a objectForKey:@"postalName"]
                                                      address1:[a objectForKey:@"address1"]
                                                      address2:[a objectForKey:@"address2"]
                                                          city:[a objectForKey:@"city"] 
                                                         state:[a objectForKey:@"state"] 
                                                           zip:[a objectForKey:@"zip"] 
                                                       primary:[[a objectForKey:@"primary"]intValue]==0?NO:YES 
                                                        withID:[a objectForKey:@"id"] ];
        
        
        [tempArray addObject:currentAddress];
    }
    
    self.addressBook = tempArray; 
    NSLog(@"$$$$$$$$$$$$ ADDRESSES %@",addressBook);
}

-(void)recivedOneCreditCard:(NSDictionary*)responseDictionary{
    
    CreditCard *currentPaymentMeth = [[CreditCard alloc]initWithCCtype:[responseDictionary objectForKey:@"cardType"]
                                                         cardfirstName:[responseDictionary objectForKey:@"firstName"]
                                                          cardlastName:[responseDictionary objectForKey:@"lastName"]
                                                                toName:[responseDictionary objectForKey:@"billingAddressName"]
                                                            cardNumber:[responseDictionary objectForKey:@"lastFour"]
                                                              expMonth:[responseDictionary objectForKey:@"expMonth"]
                                                               expYear:[responseDictionary objectForKey:@"expYear"]
                                                                  cvv2:@""
                                                            toAddress1:[responseDictionary objectForKey:@"address1"]
                                                            toAddress2:[responseDictionary objectForKey:@"address2"]
                                                                  city:[responseDictionary objectForKey:@"city"]
                                                                 state:[responseDictionary objectForKey:@"state"]
                                                                   zip:[responseDictionary objectForKey:@"zip"]
                                                          billingAddID:[responseDictionary objectForKey:@"billingAddressId"]
                                                             paymentID:[responseDictionary objectForKey:@"id"]
                                                         primaryMethod:[[responseDictionary objectForKey:@"primary"]intValue]==0?NO:YES ];
    
  
   
    //update the new card if it exisits in the wallet
    for(int i =0;i<[wallet count];i++){
        if([((CreditCard*)[wallet objectAtIndex:i]).paymentID isEqualToString:currentPaymentMeth.paymentID]){
            [self.wallet  removeObjectAtIndex:i ];
            break;break;
        }
    }
    
    // if the new cc is set to primary go through the address book and set the rest to no then add the new address to the addressbook 
    if(currentPaymentMeth.isPrimary){
        for(CreditCard *c in wallet){
            c.isPrimary=NO;
        }
    }
            [wallet addObject:currentPaymentMeth];
    EditItemViewController * editItemViewController = [[EditItemViewController alloc]init ];
 
    dispatch_async(dispatch_get_main_queue(), ^{
           [accountNavigationController popViewControllerAnimated:YES];
        [editItemViewController creditCardResponse]; 
        });
}
-(void)recivedManyCreditCards:(NSArray*)items{
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for(NSDictionary* a in items){       
        CreditCard *currentPaymentMeth = [[CreditCard alloc]initWithCCtype:[a objectForKey:@"cardType"]
                                                             cardfirstName:[a objectForKey:@"firstName"]
                                                              cardlastName:[a objectForKey:@"lastName"]
                                                                    toName:[a objectForKey:@"billingAddressName"]
                                                                cardNumber:[a objectForKey:@"lastFour"]
                                                                  expMonth:[a objectForKey:@"expMonth"]
                                                                   expYear:[a objectForKey:@"expYear"]
                                                                      cvv2:@""
                                                                toAddress1:[a objectForKey:@"address1"]
                                                                toAddress2:[[a objectForKey:@"address2"]isKindOfClass:[NSNull class]]?@"":[a objectForKey:@"address2"]
                                                                      city:[a objectForKey:@"city"]
                                                                     state:[a objectForKey:@"state"]
                                                                       zip:[a objectForKey:@"zip"]
                                                              billingAddID:[a objectForKey:@"billingAddressId"]
                                                                 paymentID:[a objectForKey:@"id"]
                                                             primaryMethod:[[a objectForKey:@"primary"]intValue]==0?NO:YES ];
      
        [tempArray addObject:currentPaymentMeth];
        
    }
    self.wallet=tempArray;
}


-(void)recivedManyOrders:(NSDictionary*)responseDictionary{

    NSLog(@"IN MANY ORDERS");
    NSMutableArray * tempCurrentOrders = [[NSMutableArray alloc]init];
    NSArray * orderItemsArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"items"]];// puts all the orders into and array
    
    for(NSDictionary* O in orderItemsArray){//for each order
             
        NSMutableArray *currentOrderItems= [[NSMutableArray alloc]init];
    
        for(NSDictionary *I in[O objectForKey:@"items"] ){
          //get the individual products first
            
            Item *currentItem=[[Item alloc]initWithItemName:[I  objectForKey:@"productName"]
                                                     itemID:[I  objectForKey:@"id"]
                                                     status:[[I objectForKey:@"status"] isKindOfClass:[NSNull class]]?@"":[I  objectForKey:@"status"]
                                                      price:[I  objectForKey:@"grandTotal"]
                                               qtyPurchased:[I   objectForKey:@"quantity"]
                                                   imageUrl:[I   objectForKey:@"imageUrl"]
                                               shippingUrls:[I  objectForKey:@"shippingUrls"]];       
            
           
           
            // add url to image cache
            if(![[self.imageCache allKeys]containsObject:[I  objectForKey:@"imageUrl"]])
                [self.imageCache setObject:@"*" forKey:[I  objectForKey:@"imageUrl"]];
            
            
            currentItem.itemImage=[imageCache objectForKey:[I  objectForKey:@"imageUrl"]];
            [currentOrderItems addObject:currentItem];
        }
        
        Order *currentorder=[[Order alloc]initWithOrderNumber:[O objectForKey:@"orderId"] 
                                                  orderStatus: [[O objectForKey:@"status"] isKindOfClass:[NSNull class]]?@" ":[O objectForKey:@"status"] 
                                                 purchaseDate: [O objectForKey:@"orderDate"]
                                                        items: currentOrderItems  
                                                   orderTotal: [O objectForKey:@"grandTotal"]        
                                                shippingTotal: [O objectForKey:@"shippingTotal"]
                                                     subTotal: [O objectForKey:@"subTotal"]
                                                     taxTotal: [O objectForKey:@"taxTotal"]
                                                 isCancelable:[O objectForKey:@"cancelable"]];
        if(orderCurrentPage!=0){
            [orders addObject:currentorder];  
        }
        else {
                [tempCurrentOrders addObject:currentorder];  
        }
            
         
    }   
    if(orderCurrentPage==0){
      [orders removeAllObjects];
    orders=tempCurrentOrders;                    
                                                                      }
                                                                        
    orderPages=[[responseDictionary objectForKey:@"pages"] intValue];
    orderCurrentPage=[[responseDictionary objectForKey:@"currentPage"] intValue];
    
    [self loadImages];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Root activity controller %@", rootActivityViewController.view);
        rootActivityViewController.view = rootActivityViewController.purchasesTableView;
        [rootActivityViewController.purchasesTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.loadIndicator stopAnimating];
     });
   }

-(void)recivedOneOrder:(NSDictionary*)responseDictionary{
 
  
    NSMutableArray *currentOrderItems= [[NSMutableArray alloc]init];
    
    for(NSDictionary *I in[responseDictionary objectForKey:@"items"] ){
        //get the individual products first
        Item *currentItem=[[Item alloc]initWithItemName:[I  objectForKey:@"productName"]
                                                 itemID:[I  objectForKey:@"id"]
                                                 status:[[I objectForKey:@"status"] isKindOfClass:[NSNull class]]?@"":[I  objectForKey:@"status"]
                                                  price:[I  objectForKey:@"grandTotal"]
                                           qtyPurchased:[I   objectForKey:@"quantity"]
                                               imageUrl:[I   objectForKey:@"imageUrl"]
                                           shippingUrls:[I  objectForKey:@"shippingUrls"]];       
        
        
        // add url to image cache
        if(![[self.imageCache allKeys]containsObject:[I  objectForKey:@"imageUrl"]])
            [self.imageCache setObject:@"*" forKey:[I  objectForKey:@"imageUrl"]];
        
        
        currentItem.itemImage=[imageCache objectForKey:[I  objectForKey:@"imageUrl"]];
        [currentOrderItems addObject:currentItem];
    }
    
    Order *currentorder=[[Order alloc]initWithOrderNumber:[responseDictionary objectForKey:@"orderId"] 
                                              orderStatus: [[responseDictionary objectForKey:@"status"] isKindOfClass:[NSNull class]]?@" ":[responseDictionary objectForKey:@"status"] 
                                             purchaseDate: [responseDictionary objectForKey:@"orderDate"]
                                                    items: currentOrderItems  
                                               orderTotal: [responseDictionary objectForKey:@"grandTotal"]        
                                            shippingTotal: [responseDictionary objectForKey:@"shippingTotal"]
                                                 subTotal: [responseDictionary objectForKey:@"subTotal"]
                                                 taxTotal: [responseDictionary objectForKey:@"taxTotal"]
                                                isCancelable:[responseDictionary objectForKey:@"cancelable"]];

    currentorder.individuallyUpdated=YES;
   
    NSDictionary *orderAddressDict =[responseDictionary objectForKey:@"shippingAddress"];
     
    Address *currentOrderAddress=[[Address alloc]initWithName:[orderAddressDict objectForKey:@"postalName"]
                                                     address1:[orderAddressDict objectForKey:@"address1"] 
                                                     address2:[orderAddressDict objectForKey:@"address2"]
                                                         city:[orderAddressDict objectForKey:@"city"]
                                                        state:[orderAddressDict objectForKey:@"state"]
                                                          zip:[orderAddressDict objectForKey:@"zip"]
                                                      primary:[orderAddressDict objectForKey:@"primary"]
                                                       withID:[orderAddressDict objectForKey:@"id"]];
    
    currentorder.orderAddress=currentOrderAddress;
    [currentorder addPaymentInfoObject:[responseDictionary objectForKey:@"paymentInformation"]];

     for(int i=0;i<[orders count];i++){
        if([((Order*)[orders objectAtIndex:i]).orderNumber isEqualToString:currentorder.orderNumber]){
            [orders removeObjectAtIndex:i];
            [orders insertObject:currentorder atIndex:i];
            break;
            }
        }
    

        
    
            dispatch_async(dispatch_get_main_queue(), ^{
                OrderDetailViewController * orderDetailViewController = [[OrderDetailViewController alloc]init];
                
               orderDetailViewController.currentOrder = currentorder;
               [rootActivityViewController.navigationController pushViewController:orderDetailViewController animated:YES];
            });
    
   }   




-(void)didReciveImageData:(NSData*)thedata from:(NSString*)url{
    UIImage* currentImage = [[UIImage alloc]initWithData:thedata];
    if(currentImage) 
           [imageCache setObject:currentImage forKey:url];
    [self matchItemstoPictures];
    
}
#pragma Mark - Error Msg
-(void)displayErrorMsgToUserWithTitle:(NSString*)title
                               andMsg:(NSString*)msg{
    [generalAlert setTitle:title];
    [generalAlert setMessage:msg];
    [generalAlert setDelegate:self];

if(![generalAlert isVisible])    
    [generalAlert show];
    
}


-(void)matchItemstoPictures{
       // go through the orders and set images to each of the items
        for(Order* o in orders){
            for(Item *i in o.items)
                i.itemImage=[imageCache objectForKey:i.imageUrl];
      
            [o performSelectorOnMainThread:@selector(organizeImageStack) withObject:nil waitUntilDone:YES];
        }
    [rootActivityViewController performSelectorOnMainThread:@selector(reloadImages) withObject:nil waitUntilDone:YES];
    [rootActivityViewController.purchasesTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

    
}

#pragma Logout
-(void)logout{
      if(!stayLoggedIn){
        if(!saveInfoBOOl){
            [keychain setObject:@"" forKey:(__bridge  id)kSecValueData];
        }
    }

    [accountInfo setObject:@"" forKey:@"userId"];
    //accountInfo=nil;
    //wallet=nil;
    //orders=nil;
    //addressBook=nil;
    
    orderCurrentPage=0;
    LogInViewController *loginview =[[LogInViewController alloc]init];
    [tabBarController presentModalViewController:loginview animated:YES];
}



@end
