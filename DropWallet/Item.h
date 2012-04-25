//
//  Item.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject{

    NSString    *itemDesc,*itemID;
    UIImage     *itemImage;
    int         *qtyPurchased;
    double      price;
    

}
@property (nonatomic,retain) NSString *itemDesc,*itemID;
@property (nonatomic,retain) UIImage  *itemImage;
@property  int *qtyPurchased;
@property double price;


-(id)initWithItemDesc:(NSString *)iDesc			
               itemID:(NSString*)iID
                price:(NSString*)iPrice
         qtyPurchased:(NSString*)qty
            itemImage:(UIImage*) image;
@end


