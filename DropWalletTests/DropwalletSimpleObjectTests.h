//
//  DropwalletSimpleObjectTests.h
//  DropWallet
//
//  Created by Paul Rudolph on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "Item.h"
#import "Order.h"
@interface DropwalletSimpleObjectTests : SenTestCase{
    @private
    Item *testItem1,*testItem2,*testItem3;
    
    Order *testOrder;
    
}

@end
