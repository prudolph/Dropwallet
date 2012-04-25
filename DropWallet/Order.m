//
//  Purchase.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Order.h"

@implementation Order



//Strings
@synthesize orderNumber,orderStatus,purchaseDate;
@synthesize items;
@synthesize orderImageStack;
@synthesize orderTotal,orderShippingTotal,orderSubTotal;

-(id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(id)initWithOrderNumber:(NSString *)   oNumber				
             orderStatus:(NSString*)    oStatus
            purchaseDate:(NSString*)      oPurchDate
                   items:(NSArray*)oItems
           shippingTotal:(NSString *)     oShipTotal{
    

    self = [super init];
    
    self.items =                [NSArray arrayWithArray:oItems];
    self.orderNumber=           oNumber;
    self.orderStatus=           oStatus;
    self.purchaseDate =         oPurchDate;
    self.items=                 oItems;
    self.orderShippingTotal=    [oShipTotal doubleValue];

    

    
    NSMutableArray *orderImgs = [[NSMutableArray alloc]init];
    for ( Item* i in self.items){
        self.orderTotal+=i.price;
        [orderImgs addObject:i.itemImage];
    }
    self.orderImageStack = orderImgs;
    
    return self;
}

-(NSString *)description
{
	NSString *descriptionString=[NSString stringWithFormat:@"OrderNumber: %@ \n Purchase Date: %@\n OrderStatus: %@\n Shipping Total: %.2f\n  \n",self.orderNumber,
                                                          self.purchaseDate,
                                                          self.orderStatus,
                                                          self.orderShippingTotal];
    
        return descriptionString;
}

@end
