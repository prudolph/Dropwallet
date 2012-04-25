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
      billfirstName:  (NSString*)inBillFname
       billlastName:  (NSString*)inBillLname
         cardNumber:  (NSString*)inCCNum
           expMonth:  (NSString*)inExpMonth
            expYear:  (NSString*)inExpYear
               cvv2:  (NSString*)inCvv2
         toAddress1:  (NSString*)inToAddress1
               city:  (NSString*)inCity
              state:  (NSString*)inState     
                zip:  (NSString*)inZip
          paymentID: (NSString*)inPaymentID{
    
    self = [super init];
    self.billingAddress = [[Address alloc]initWithName: [NSString stringWithFormat:@"%@ %@",        inBillFname,inBillLname] 
                                            address1:inToAddress1 
                                            city:inCity 
                                            state:inState 
                                            zip:inZip 
                                            primary:NULL
                                            withID:NULL
                           
];

    self.ccType = inCCType;
    self.cardFirstName=inCardFname;
    self.cardLastName = inCardLname;
    self.cardNumber=inCCNum;
    self.expMonth = inExpMonth;
    self.expYear = inExpYear;
    self.cvv2 = inCvv2;
    self.paymentID=inPaymentID;
    return self;
}


-(NSString *)description{
     NSString *ccDesc = 
    [NSString stringWithFormat:@"%@\n%@\n%@/%@    %@\n %@ %@\n\n %@ ",self.ccType,
                                                                      self.cardNumber,
                                                                      self.expMonth,
                                                                      self.expYear,
                                                                      self.cvv2, 
                                                                      self.cardFirstName,
                                                                      self.cardLastName,
                                                                      self.billingAddress];
    
    return ccDesc;
}
@end
