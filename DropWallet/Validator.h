//
//  Validator.h
//  DropWallet
//
//  Created by Paul Rudolph on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Address.h"
#import "CreditCard.h"


//Define cc Label Tags
#define CCNUMTAG 0
#define CCTYPETAG   1
#define CCFNAMETAG 2
#define CCLNAMETAG 3
#define CCEXPMOTAG 4
#define CCEXPYRTAG 5
#define CCCCV2TAG 6

//define Address Lable tags
#define ADD_TONAMETAG 7
#define ADD_ADDRESS1TAG 8
#define ADD_ADDRESS2TAG 9
#define ADD_CITYTAG 10
#define ADD_STATETAG 11
#define ADD_ZIPTAG 12
#define ADD_PRITAG 13

@interface Validator : NSObject
@property(nonatomic,retain)NSDictionary *validationMsgs,*statesDict;
@property(nonatomic,retain)NSString *errorString; 
@property(nonatomic,retain)Address *validateAddress;
@property(nonatomic,retain)CreditCard *validateCC;

-(NSString*)validate:(id)object;
-(NSString*)validateCCForUpdate:(id)object;
-(BOOL)is:(NSString*)input aValid:(int) type;
-(BOOL)zip:(NSString*)zip AndStateMatch:(NSString*)state;
-(BOOL)isThis:(NSString*)ccNumber andThis:(NSString*)CCV2 aValid:(NSString*)ccType;
-(BOOL)zipCode:(int)code isBetween:(int)low and:(int)high;
-(NSString*)checkThisOldPassword:(NSString*)oldPassword
                 currentPassword:(NSString*)currentPassword
                     newPassword:(NSString*)newPass 
                  andRetypedPass:(NSString*) retypePass;
-(NSString*)whatIsThisCardType:(NSString*)cardNumber;
-(NSString*)isThisValidUsername:(NSString *)uname andPassWord:(NSString*)pass;
@end

