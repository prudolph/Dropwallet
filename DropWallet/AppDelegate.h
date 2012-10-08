//
//  AppDelegate.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "Address.h"
#import "CreditCard.h"
#import "Order.h"
#import "SBJson.h"
#import "Reachability.h"
#import "EditItemViewController.h"
#import "OrderDetailViewController.h"

@class RootActivityViewController;
@class RootAccountViewController;
@class RootHelpViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITextFieldDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>{
  

    //User data arrays      
    NSMutableArray *addressBook,
                   *wallet,
                   *orders;
    int orderPages,orderCurrentPage,walletPages,walletCurrentPage,addressPages,addressCurrentPage;
    
    NSMutableDictionary *accountInfo,*imageCache;
    NSDictionary *appText;
    KeychainItemWrapper *keychain;
    
    Reachability* hostReach;

}

//Navigation Controllers
@property (strong, nonatomic) UIWindow                   *window;
@property (strong, nonatomic) UITabBarController         *tabBarController;
@property (strong, nonatomic) UINavigationController     *activityNavigationController,
                                                         *accountNavigationController,
                                                         *helpNavigationController;
@property (strong, nonatomic) RootAccountViewController  *rootAccountViewController;
@property (strong, nonatomic) RootActivityViewController *rootActivityViewController;
@property (strong, nonatomic) RootHelpViewController     *rootHelpViewController;


//User Data Arrays
@property (nonatomic,retain) NSMutableArray             *addressBook,
                                                        *wallet,
                                                        *orders;

@property (nonatomic,retain) NSMutableDictionary        *accountInfo,*imageCache;
@property (nonatomic,retain) NSDictionary               *appText;
@property (nonatomic,retain) UIAlertView                *generalAlert;

@property (nonatomic,retain)KeychainItemWrapper *keychain;
@property (nonatomic,retain)SBJsonParser *jsonParser;
@property (nonatomic,retain)SBJsonWriter *jsonWriter;

@property (nonatomic,retain) Reachability* hostReach;
@property(nonatomic,retain) UIActivityIndicatorView *loadIndicator;
@property (nonatomic)    int orderPages,orderCurrentPage,walletPages,walletCurrentPage,addressPages,addressCurrentPage;

@property(nonatomic)BOOL saveInfoBOOl,stayLoggedIn,SYSdemo;
//logo
@property(nonatomic,retain)UIImageView * logoImgView;
@property(nonatomic,retain)UILabel * titleLabelView;


-(void)loadAddressBook;
-(void)loadWallet;
-(void)loadOrders;
-(void)loadImages;
//Server Functions
-(void)updatePersonalInfoToServer:(NSString*)fname
                      andLastname:(NSString*)lname;
-(void)updateNewPasswordToServer:(NSString*)newPass 
              andConfirmPassword: (NSString*)confirmPass
                  andOldPassword:(NSString*)oldPass;
-(void)checkCredentials;
//Order FUnction
-(void)getSpecificOrder:(Order *)orderToUpdate;
-(void)cancelOrder:(NSString*) orderNumber;
//address funcs
-(BOOL)updateModifiedAddressToServer:(Address *)modifiedAddress;
-(BOOL)updateNewAddressToServer:(Address *)newAddress;
-(BOOL)removeAddress:(Address*)addressToBeRemoved;
//creditcard func s
-(BOOL)updateModifiedCreditCardToServer:(CreditCard *)modifiedCreditCard;
-(void)UpdateNewCreditCardToServer:(CreditCard *)newCreditCard;
-(BOOL)removeCreditCard:(CreditCard*)creditCardToBeRemoved;

//URL CONNECTIONS
-(BOOL)testConnection;
-(void)sendHttpRequestWithType:(NSString*)type andBody:(NSData *)body toURL:(NSString *)urlSuffix;
-(NSData *)deleteFromURL:(NSString *)urlSuffix; 
-(void)getImageSyncFromURL:(NSString *)imageUrl; 

//URL DELEGATE FUNCTIONS
-(void)didReciveData:(NSData*)thedata;
-(void)didReciveImageData:(NSData*)thedata from:(NSString*)url;
-(void)recivedOneAddress:(NSDictionary*)responseDictionary;
-(void)recivedManyAddresses:(NSArray*)items;
-(void)recivedOneCreditCard:(NSDictionary*)responseDictionary;
-(void)recivedManyCreditCards:(NSArray*)items;
-(void)recivedManyOrders:(NSDictionary*)responseDictionary;
-(void)recivedOneOrder:(NSDictionary*)responseDictionary;

//display error msg
-(void)displayErrorMsgToUserWithTitle:(NSString*)title
                               andMsg:(NSString*)msg;
//MISC
-(void)matchItemstoPictures;

//Logout
-(void)logout;
   
@end
