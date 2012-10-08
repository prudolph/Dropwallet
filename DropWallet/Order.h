//
//  Purchase.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/* An order contains all the items that were purchased together along with billing and shipping information. 
 *
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Item.h"
#import "ScrollingImage.h"
#import "Address.h"
#import "CreditCard.h"
@interface Order : NSObject{
      
    NSString    *orderNumber,*orderStatus,*purchaseDate,*paymentInfo;
    NSArray     *items,*orderImageStack;
   
    Address     *orderAddress;
    double      orderTotal,orderTaxTotal,orderShippingTotal,orderSubTotal;
    ScrollingImage * scrollimage; 

}
@property (nonatomic,retain) NSString     *orderNumber,
                                          *orderStatus,
                                          *purchaseDate,*paymentInfo;

@property (nonatomic,retain) NSArray      *items,*orderImageStack;

@property  double       orderTotal,
                        orderTaxTotal,
                        orderShippingTotal,
                        orderSubTotal;

@property(nonatomic,retain) Address         *orderAddress;
@property(nonatomic,retain) ScrollingImage *scrollimage;
@property(nonatomic) BOOL individuallyUpdated;
@property(nonatomic) BOOL cancelable;

-(id)initWithOrderNumber:(NSString *)   oNumber				
             orderStatus:(NSString*)    oStatus
            purchaseDate:(NSString*)    oPurchDate
                   items:(NSArray*)     oItems
              orderTotal:(NSString*)    oGrandTotal
           shippingTotal:(NSString *)   oShipTotal
                subTotal:(NSString*)    oSubTotal
                taxTotal:(NSString*)    oTaxTotal
            isCancelable:(NSString*)    oCancel;

-(void)organizeImageStack;
-(void)addPaymentInfoObject:(NSString *)object;

@end
