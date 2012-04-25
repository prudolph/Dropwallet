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
#import "Item.h"
@interface Order : NSObject{
    NSString    *orderNumber,*orderStatus,*purchaseDate;
    NSArray     *items,*orderImageStack;

    double      orderTotal,orderShippingTotal,orderSubTotal;
    

}
@property (nonatomic,retain) NSString     *orderNumber,
                                          *orderStatus,
                                          *purchaseDate;

@property (nonatomic,retain) NSArray      *items,*orderImageStack;

@property  double       orderTotal,
                        orderShippingTotal,
                        orderSubTotal;

-(id)initWithOrderNumber:(NSString *)   oNumber				
             orderStatus:(NSString*)    oStatus
            purchaseDate:(NSString*)    oPurchDate
                   items:(NSArray*)     oItems
           shippingTotal:(NSString *)   oShipTotal;
@end
