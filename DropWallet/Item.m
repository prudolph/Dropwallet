//
//  Item.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize itemID,itemDesc;
//Image
@synthesize itemImage;
//int
@synthesize qtyPurchased;
//double
@synthesize price;

-(id)init{
    self = [super init];
    if (self) {
    }     
    return self;
}
-(id)initWithItemDesc:(NSString *)iDesc			
               itemID:(NSString*)iID
                price:(NSString*)iPrice
         qtyPurchased:(NSString*)qty
            itemImage:(UIImage*) image{

        self = [super init];
      
        self.itemDesc=iDesc;
        self.itemID = iID;
        self.price = [iPrice doubleValue];
        self.qtyPurchased=(int*)[qty integerValue];
        self.itemImage=image;
    
    return self;
}
@end
