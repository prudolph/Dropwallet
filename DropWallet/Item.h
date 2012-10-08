//
//  Item.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject{

    
    NSString    *itemName,*itemID,*status,*imageUrl;
    UIImage     *itemImage;
    NSMutableDictionary     *shippingUrls;
    int         *qtyPurchased;
    double      itemTotal;
    

}
@property (nonatomic,retain) NSString *itemName,*itemID,*status,*imageUrl;
@property (nonatomic,retain) UIImage  *itemImage;
@property (nonatomic,retain)  NSMutableDictionary *shippingUrls;
@property  int *qtyPurchased;
@property double price;


-(id)initWithItemName:(NSString *)iName			
               itemID:(NSString*)iID
               status:(NSString*)iStatus
                price:(NSString*)iPrice
         qtyPurchased:(NSString*)qty
             imageUrl:(NSString*)iUrl
         shippingUrls:(NSArray*)sUrls ;

-(NSMutableDictionary*)createDictionaryForUrls:(NSArray*)urlArray;
-(NSString*)convertStatus:(NSString*)inStatus;
@end

