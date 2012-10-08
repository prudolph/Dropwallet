//
//  CreditCard.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreditCard.h"

@implementation CreditCard

//NSStrings
@synthesize paymentID,
            ccType,
            cardFirstName,
            cardLastName,
            cardNumber,
            expMonth,
            expYear,
            cvv2;
//prim
@synthesize isPrimary;
//Address
@synthesize billingAddress;

-(id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
}
-(id)initWithCCtype:  (NSString *)inCCType			
      cardfirstName:  (NSString*)inCardFname
       cardlastName:  (NSString*)inCardLname
             toName:  (NSString*)inToName
         cardNumber:  (NSString*)inCCNum
           expMonth:  (NSString*)inExpMonth
            expYear:  (NSString*)inExpYear
               cvv2:  (NSString*)inCvv2
         toAddress1:  (NSString*)inToAddress1
         toAddress2:  (NSString*)inToAddress2
               city:  (NSString*)inCity
              state:  (NSString*)inState     
                zip:  (NSString*)inZip
       billingAddID:  (NSString*)inBillingAddId
          paymentID:  (NSString*)inPaymentID
      primaryMethod:  (BOOL) primary  {
    
    self = [super init];
    self.billingAddress = [[Address alloc]initWithName: [self checkInData:inToName]
                                              address1:[self checkInData:inToAddress1]
                                              address2:[self checkInData:inToAddress2]
                                                  city: [self checkInData:inCity]
                                                 state: [self checkInData:inState]
                                                   zip: [self checkInData:inZip]
                                               primary:NULL
                                                withID: [self checkInData:inBillingAddId]];

    self.ccType =       [self checkInData:inCCType ];
    self.cardFirstName= [self checkInData:inCardFname ];
    self.cardLastName = [self checkInData:inCardLname ];
    self.cardNumber=    [self checkInData:inCCNum ];
    self.expMonth =     [self checkInData:inExpMonth ];
    self.expYear =      [self checkInData:inExpYear ];
    self.cvv2 =         [self checkInData:inCvv2 ];
    self.paymentID=     [self checkInData:inPaymentID ];
    self.isPrimary=primary;

    return self;
}
-(NSString *)checkInData:(NSString*)inString{
       if([inString isKindOfClass:[NSNull class]]){
        return @"";
        }
    else {
        return [ inString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
}

-(NSString *)description{
      
    return  [NSString stringWithFormat:@"Type:%@\n Card#:%@\n expDate: %@/%@\n ccv2:%@\n cardFname:%@\n CardLname%@\n Primary?:%@\n Billing: %@ ",self.ccType,
                                                                                                                              self.cardNumber,
                                                                                                                              self.expMonth,
                                                                                                                              self.expYear,
                                                                                                                              self.cvv2, 
                                                                                                                              self.cardFirstName,
                                                                                                                              self.cardLastName,
                                                                                                                              self.isPrimary?@"YES":@"NO",
                                                                                                                              self.billingAddress];
    
}


-(NSData*)asDataForUpdate:(BOOL)updatingCC{
    NSString *CCBody,*addressBody;
    
    if([self.billingAddress.addressID length]>0){        
    addressBody=[NSString stringWithFormat:@"&billingAddressId=%@",self.billingAddress.addressID];
  }
    else{
       
    addressBody=[NSString stringWithFormat:@"&address1=%@&city=%@&state=%@&zip=%@&postalName=%@",self.billingAddress.address1,self.billingAddress.city,self.billingAddress.state,self.billingAddress.zip,self.billingAddress.toName];
        
        
        if(!(  ([self.billingAddress.address2 isEqualToString:@"(null)"]) ||
             ([self.billingAddress.address2 isEqual:@"(null)"]) ||
             ([self.billingAddress.address2 isKindOfClass:[NSNull class]]) ||
             ([self.billingAddress.address2 isEqual:NULL])||
             ([self.billingAddress.address2 isEqual:@""])||
             (self.billingAddress.address2 ==NULL)
             )){
            addressBody=[addressBody stringByAppendingFormat:@"&address2=%@",self.billingAddress.address2];
        }

        
    }
    
    if(updatingCC){
         CCBody=[NSString stringWithFormat:@"cvv2=%@&expYear=%@&expMonth=%@&firstName=%@&lastName=%@&cardType=%@&primary=%@",self.cvv2,self.expYear,self.expMonth,self.cardFirstName,self.cardLastName,[self.ccType uppercaseString],self.isPrimary?@"true":@"false"];
    }
    else {
        
    
    CCBody=[NSString stringWithFormat:@"cvv2=%@&expYear=%@&expMonth=%@&firstName=%@&lastName=%@&creditCardNumber=%@&cardType=%@&primary=%@",self.cvv2,self.expYear,self.expMonth,self.cardFirstName,self.cardLastName,self.cardNumber,[self.ccType uppercaseString],self.isPrimary?@"true":@"false"];
    }
    
    CCBody =[CCBody stringByAppendingFormat:@"%@",addressBody];
    NSLog(@"CC AS DATA: %@",CCBody);

    return [CCBody dataUsingEncoding:NSUTF8StringEncoding];
}



@end
