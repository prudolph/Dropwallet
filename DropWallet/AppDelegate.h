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
@class RootActivityViewController;
@class RootAccountViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITextFieldDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>{
  

    //User data arrays      
    NSMutableArray *addressBook,
                   *wallet,
                   *reciepts;
    
    NSMutableDictionary *accountInfo,*appText;

    KeychainItemWrapper *keychain;
    
}

//Navigation Controllers
@property (strong, nonatomic) UIWindow                   *window;
@property (strong, nonatomic) UITabBarController         *tabBarController;
@property (strong, nonatomic) UINavigationController     *activityNavigationController,
                                                         *accountNavigationController;
@property (strong, nonatomic) RootAccountViewController  *rootAccountViewController;
@property (strong, nonatomic) RootActivityViewController *rootActivityViewController;

//User Data Arrays
@property (nonatomic,retain) NSMutableArray             *addressBook,
                                                        *wallet,
                                                        *recipts;

@property (nonatomic,retain) NSMutableDictionary        *accountInfo,*appText;

@property (nonatomic,retain)KeychainItemWrapper *keychain;

-(void)createAddressBook:(NSString *)path;
-(void)createWallet:(NSString*) path;

-(void)getUserInfo;
//Server Functions
-(BOOL)updatePersonalInfoToServer:(NSString*)fname
                      andLastname:(NSString*)lname;
-(BOOL)updatePasswordToServer:(NSString*)newPass;
-(BOOL)checkCredentials;

//address funcs
-(BOOL)updateModifiedAddressToServer:(Address *)modifiedAddress
                        andOldAddress:(Address*)oldAddress;
-(BOOL)updateNewAddressToServer:(Address *)newAddress;
-(BOOL)removeAddress:(Address*)addressToBeRemoved;
//creditcard func s
-(BOOL)updateModifiedCreditCardToServer:(CreditCard *)modifiedCreditCard
                       andOldCreditcard:(CreditCard*)oldCreditCard;
-(BOOL)UpdateNewCreditCardToServer:(CreditCard *)newCreditCard;
-(BOOL)removeCreditCard:(CreditCard*)creditCardToBeRemoved;



//display error msg
-(void)displayErrorMsgToUserWithTitle:(NSString*)title
                               andMsg:(NSString*)msg;

@end
