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
#import "LogInViewController.h"
#import "Address.h"
#import "CreditCard.h"

@implementation AppDelegate

@synthesize window;

@synthesize tabBarController;

@synthesize rootActivityViewController,
            rootAccountViewController;

@synthesize activityNavigationController,
            accountNavigationController;

//User data Arrays
@synthesize addressBook,
            wallet,
            recipts,
            accountInfo,appText;

//keychain
@synthesize keychain;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
 
    NSString *stringsPath = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    
    appText= [[NSDictionary alloc]initWithContentsOfFile:stringsPath]; 
    
 
    
    // Initalize userData
    self.accountInfo=   [[NSMutableDictionary alloc]init];
    self.addressBook =  [[NSMutableArray alloc] init];
    self.wallet =       [[NSMutableArray alloc] init];
    self.recipts =      [[NSMutableArray alloc] init];

    
    //Setup keychain wrapper
	keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"mainLogin" accessGroup:nil];
    
   [keychain resetKeychainItem];
    

    // set up naviation hierarchy
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
   
    //rootviewcontrollers
    self.rootActivityViewController = [[RootActivityViewController alloc] initWithNibName:@"RootActivityViewController" bundle:nil];    
    self.rootAccountViewController = [[RootAccountViewController alloc] initWithNibName:@"RootAccountViewController" bundle:nil];
        //Call init to ensure the titles are set to the tab bar buttons
        [self.rootAccountViewController init];
        [self.rootAccountViewController init];

    
        //Navigation controller - Activity
        self.activityNavigationController = [[UINavigationController alloc]initWithRootViewController:self.rootActivityViewController];
        self.activityNavigationController.navigationBar.tintColor = [UIColor blackColor];//set color of navigation bar 
    
        //Navigation controller - Account
        self.accountNavigationController = [[UINavigationController alloc]initWithRootViewController:self.rootAccountViewController];
        self.accountNavigationController.navigationBar.tintColor = [UIColor blackColor];//set color of navigation bar 
    
    //set view controllers to Tab barController
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.activityNavigationController, self.accountNavigationController, nil];
    
    
     self.window.rootViewController = self.tabBarController;
    UIColor *bkcolor = [[UIColor alloc] initWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                @"grayLinen" ofType:@"png"]] ];
    [self.window setBackgroundColor:bkcolor];
    [self.window makeKeyAndVisible];
   
     
    // check for user credentials
    //if the keychain is empty or the credentials are invalid
     if (([[keychain objectForKey:(__bridge  id)kSecValueData] isEqual:@""]) || 
        ([[keychain objectForKey:(__bridge id)kSecAttrAccount] isEqual:@""]) ||
         (![self checkCredentials])) {

        LogInViewController *loginViewController = [[LogInViewController alloc] init];
        [self.tabBarController presentModalViewController:loginViewController animated:NO];
         
    }

     
    [self getUserInfo];
       

return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma Mark - Retrive Data
-(void)getUserInfo{

    [accountInfo setObject:@"Paul" forKey:@"fName"];
    [accountInfo setObject:@"Rudolph" forKey:@"lName"];
    
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:
                             @"addressesList" ofType:@"plist"];
    [self createAddressBook:addressPath];
    [self createWallet:addressPath];
    
}

-(BOOL)checkCredentials{
    NSLog(@"checking Credentials against the server...");
#warning  TODO check users creds valid
    
    return YES;

}
#pragma Mark -SERVER FUNCTIONS
-(BOOL)updatePersonalInfoToServer:(NSString*)fname
                         andLastname:(NSString*)lname{
    NSLog(@"updating personal info to server");
    [accountInfo setObject:fname forKey:@"fName"];
    [accountInfo setObject:lname forKey:@"lName"];
    
    return YES; 
}

-(BOOL)updatePasswordToServer:(NSString*)newPass{
    NSLog(@"Updating new password to server...");
    // Store password to keychain
    [keychain setObject:newPass forKey:(__bridge  id)kSecValueData];   
    return YES;
    
}
//Address
-(BOOL)updateModifiedAddressToServer:(Address *)modifiedAddress
                       andOldAddress:(Address*)oldAddress{
    NSLog(@"Updating modified address to server");
    if(modifiedAddress.primary){
        for(Address *a in addressBook){
            a.primary=NO;
        }
    }
    int addressIndex=   [addressBook indexOfObject:oldAddress];
    [addressBook replaceObjectAtIndex:addressIndex withObject:modifiedAddress];
    
    NSLog(@"Address Book: %@",addressBook);
    return YES;
    
}

-(BOOL)updateNewAddressToServer:(Address *)newAddress{
    NSLog(@"Updating New address to server");

    for(Address* a in addressBook)
        if ([a addressIsEqualto:newAddress]) {
            [self displayErrorMsgToUserWithTitle:@"Duplicate Address" andMsg:@"Hey you already have this address saved"];
            return YES;
        }
    if(newAddress.primary){
        for(Address *a in addressBook){
            a.primary=NO;
        }
    }

    [addressBook addObject:newAddress];
    
    NSLog(@"Address Book: %@",addressBook);
return YES;
}    



-(BOOL)removeAddress:(Address*)addressToBeRemoved{
    NSLog(@"DELETE ADDRESS");      
    if([addressToBeRemoved.addressID isEqual:[NSNull class]])
        NSLog(@"WARNING: THIS ADDRESS IS MISSING AND ID!");
   
    for(Address *a in addressBook){
        if([a.addressID isEqual:addressToBeRemoved.addressID]){
            [addressBook removeObject:a];break;
           
        }
    }

               return YES;
}

//CC
-(BOOL)updateModifiedCreditCardToServer:(CreditCard *)modifiedCreditCard
                       andOldCreditcard:(CreditCard*)oldCreditCard{
    // not going to find the cc because the address has changed and objects dont match by hash value
    
     int index= [wallet indexOfObject:oldCreditCard ]; 
    [wallet replaceObjectAtIndex:index withObject:modifiedCreditCard]; 
    
    NSLog(@" Wallet : %@",wallet);
          
    return NO;
    }

-(BOOL)UpdateNewCreditCardToServer:(CreditCard *)newCreditCard{
    NSLog(@"Update new credit card to server");
    NSLog(@"Current Credit Card %@",newCreditCard);
    return YES;
}
-(BOOL)removeCreditCard:(CreditCard*)creditCardToBeRemoved{
    
    if([creditCardToBeRemoved.paymentID isEqual:[NSNull class]])
        NSLog(@"WARNING: THIS CREDITCARD IS MISSING AND ID!");
   
  
    for(CreditCard  *c in wallet){
        if([c.paymentID isEqual:creditCardToBeRemoved.paymentID]){
            [wallet  removeObject:c];break;
            
        }
    }

       
#warning call server to delete here    
    return YES;
}

#pragma Mark - Process Data

-(void)createAddressBook:(NSString *)path{
    
    Address *a = [[Address alloc] initWithName:@"Paul Rudolph" 
                                      address1:@"36 Iowa Ct." 
                                          city:@"Little Egg Harbor" 
                                         state:@"NJ" zip:@"08087" 
                                       primary:YES
                                        withID:@"0001"];
    
    Address *b = [[Address alloc] initWithName:@"Paul Rudolph " 
                                      address1:@"110 N Mole St." 
                                          city:@"Philadelphia" 
                                         state:@"PA" 
                                           zip:@"19121" 
                                       primary:NO
                                        withID:@"0002"];
    
    Address *c = [[Address alloc] initWithName:@"Paul Rudolph" 
                                      address1:@"210 E. Lake Dr." 
                                          city:@"Cherry Hill" 
                                         state:@"NJ" 
                                           zip:@"08002" 
                                       primary:NO 
                                        withID:@"0003"];
    
[self.addressBook addObject:a];
    [self.addressBook addObject:b];
    [self.addressBook addObject:c];
    }


-(void)createWallet:(NSString*) path{
    
    CreditCard *aa = [[CreditCard alloc] initWithCCtype:@"MasterCard" 
                                          cardfirstName:@"Paul" 
                                           cardlastName:@"Rudolph" 
                                          billfirstName:@"Paul" 
                                           billlastName:@"Rudolph" 
                                             cardNumber:@"4111111111111111" 
                                               expMonth:@"04" 
                                                expYear:@"2014" 
                                                   cvv2:@"222" 
                                             toAddress1:@"36 Iowa Ct." 
                                                   city:@"Little Egg Harbor" 
                                                  state:@"NJ" 
                                                    zip:@"08087"
                                                paymentID:@"0001"];

    CreditCard *bb = [[CreditCard alloc] initWithCCtype:@"Visa" 
                                          cardfirstName:@"Paul" 
                                           cardlastName:@"Rudolph" 
                                          billfirstName:@"Paul" 
                                           billlastName:@"Rudolph" 
                                             cardNumber:@"4111111111111111" 
                                               expMonth:@"04" 
                                                expYear:@"2014" 
                                                   cvv2:@"222" 
                                             toAddress1:@"36 Iowa Ct." 
                                                   city:@"Little Egg Harbor" 
                                                  state:@"NJ" 
                                                  zip:@"08087"
                                              paymentID:@"0002"];
   
    CreditCard *cc = [[CreditCard alloc] initWithCCtype:@"Discover" 
                                          cardfirstName:@"Paul" 
                                           cardlastName:@"Rudolph" 
                                          billfirstName:@"Paul" 
                                           billlastName:@"Rudolph" 
                                             cardNumber:@"4111111111111111" 
                                               expMonth:@"04" 
                                                expYear:@"2014" 
                                                   cvv2:@"222" 
                                             toAddress1:@"36 Iowa Ct." 
                                                   city:@"Little Egg Harbor" 
                                                  state:@"NJ" 
                                                    zip:@"08087"                        paymentID:@"0003"];
  [self.wallet addObject:aa];
  //[self.wallet addObject:bb];
 // [self.wallet addObject:cc];
    }

#pragma Mark - NSURLCONNECTION

- (void)loadURL:(NSString *)URI
{//URI->URL->Request
    NSURL *URL = [NSURL URLWithString:URI];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self];
    
    [conn start];
}

#pragma Mark - login procedures


-(BOOL)createPlan:(NSData *)planData {
/*
	NSString *urlString = [NSString stringWithFormat:@"%@/plans",@"Dropwallet.com];
	NSHTTPURLResponse* response = [self post:planData toURL:[NSURL URLWithString:urlString]];
	//Gets Response Header Information
	if (response) {
		NSString* newPlanURL = nil;
		if ([response respondsToSelector:@selector(allHeaderFields)]) {
			NSDictionary *header = [response allHeaderFields];
			//if location field is not empty set it to defaults
			if(![[header objectForKey:@"Location"] isKindOfClass:[NSNull class]]){
				newPlanURL = [header objectForKey:@"Location"];
			}
		}
		[self getPlansFromServer];
		return YES;
	}
 */
	return NO;
}

#pragma Mark - Error Msg
-(void)displayErrorMsgToUserWithTitle:(NSString*)title
                               andMsg:(NSString*)msg{

    UIAlertView *generalAlert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [generalAlert show];
    
}

@end
