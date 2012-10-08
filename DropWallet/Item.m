//
//  Item.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize itemName,itemID,status,imageUrl;
//Image
@synthesize itemImage;
//Array
@synthesize shippingUrls;
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
-(id)initWithItemName:(NSString *)iName			
               itemID:(NSString*)iID
               status:(NSString*)iStatus
                price:(NSString*)iPrice
         qtyPurchased:(NSString*)qty
            imageUrl:(NSString*)iUrl
         shippingUrls:(NSArray*)sUrls {

        self = [super init];
      
        self.itemName=iName;
        self.itemID = iID;
        self.status = [self convertStatus:iStatus];
        self.price = [iPrice doubleValue];
        self.qtyPurchased=(int*)[qty integerValue];
        self.imageUrl = iUrl;
        self.shippingUrls = [self createDictionaryForUrls:sUrls];
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Product name:%@ Item urls: %@",self.itemName,self.shippingUrls];
}

-(NSMutableDictionary*)createDictionaryForUrls:(NSArray*)urlArray{
    NSMutableDictionary * tempUrlDict=[[NSMutableDictionary alloc]init ];
    
    for(NSString *url in urlArray){
            if([url rangeOfString:@"ups"].location != NSNotFound){//if its ups 
                NSString *newUrl=[NSString stringWithFormat:@"https://m.ups.com/mobile/track?trackingNumber=%@&t=t#Track",[[url componentsSeparatedByString:@"="]lastObject]] ;
                [tempUrlDict setObject:newUrl forKey:[[NSArray arrayWithArray:[url componentsSeparatedByString:@"="]]lastObject]];
            }
            else {
                [tempUrlDict setObject:url forKey:[[NSArray arrayWithArray:[url componentsSeparatedByString:@"="]]lastObject]];
            }

       
    }
       return tempUrlDict;
}   

-(NSString*)convertStatus:(NSString*)inStatus{
   
    if([inStatus isEqualToString:@"SENT"]||[inStatus isEqualToString:@"PROCESSING"])
        return @"Processing";
    else if([inStatus isEqualToString:@"COMPLETED"])
        return @"Delivered";
    else if([inStatus isEqualToString:@"SHIPPED"])
        return @"Shipped";
    else if([inStatus isEqualToString:@"CANCELLED"])
        return @"Cancelled";

    else {
        return inStatus;
    }
    
}
@end
