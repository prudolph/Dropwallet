//
//  DropwalletItemTests.m
//  DropWallet
//
//  Created by Paul Rudolph on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropwalletSimpleObjectTests.h"

@implementation DropwalletSimpleObjectTests
- (void)setUp
{
    [super setUp];
   
    testItem1 = [[Item alloc]initWithItemDesc:@"Test Item1" 
                                      itemID:@"0001" 
                                       price:@"10.00" 
                                qtyPurchased:@"1" 
                                   itemImage:nil];
 
    testItem2 = [[Item alloc]initWithItemDesc:@"Test Item2" 
                                     itemID:@"0002" 
                                        price:@"20.00" 
                                 qtyPurchased:@"2" 
                                    itemImage:nil];

    testItem3 = [[Item alloc]initWithItemDesc:@"Test Item3" 
                                       itemID:@"0003" 
                                        price:@"30.00" 
                                 qtyPurchased:@"3" 
                                    itemImage:nil];
;
    
  
    testOrder =[[Order alloc]initWithOrderNumber:@"001"
                                     orderStatus:@"Testing" 
                                    purchaseDate:@"01/01/2001" 
                                           items:NULL
                                   shippingTotal:@"25.95"];   
    testOrder.items = [NSArray arrayWithObject:testItem1];

}



-(void)testItemAllocated{
    STAssertNotNil(testItem1, @"Cannot find TestItem1");
    STAssertNotNil(testItem2, @"Cannot find TestItem2");
    STAssertNotNil(testItem3, @"Cannot find TestItem3");
   // STAssertNotNil(testOrder, @"Cannot find TestItem3");
}

-(void)testItemInit{
    //test Item 
    STAssertTrue([testItem1.itemDesc isEqualToString:@"Test Item1"], @"");
    STAssertTrue([testItem1.itemID isEqualToString:@"0001"], @"");
    STAssertTrue(testItem1.price == 10.00, @"");
    STAssertTrue(testItem1.qtyPurchased == 1, @"");
    
    //test Order

    STAssertTrue([testOrder.orderNumber isEqualToString:@"001"], @"");
    STAssertTrue([testOrder.orderStatus isEqualToString:@"Testing"], @"");
    STAssertTrue([testOrder.purchaseDate isEqualToString:@"01/01/2001"], @"");
    STAssertTrue([testOrder.items count] == 1, @"");
 

}


- (void)tearDown
{
  testItem1 =nil;
  testItem2 =nil;
  testItem3 =nil;
  //testOrder= nil;
    
  [super tearDown];
}
@end
