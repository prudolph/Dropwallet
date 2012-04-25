//
//  CreditCard.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
@interface CreditCard : NSObject{

    NSString *paymentID,
             *ccType,
             *cardFirstName,
             *cardLastName,
             *cardNumber,
             *expMonth,
             *expYear,
             *cvv2;
    
    Address *billingAddress;
    
    
}

@property (nonatomic,retain) NSString *paymentID,
                                      *ccType,
                                      *cardFirstName,
                                      *cardLastName,
                                      *cardNumber,
                                      *expMonth,
                                      *expYear,
                                      *cvv2;

@property (nonatomic,retain) Address *billingAddress;

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
          paymentID: (NSString*)inPaymentID;
@end
