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
@synthesize orderNumber,orderStatus,purchaseDate,paymentInfo;
@synthesize items;
@synthesize orderImageStack;
@synthesize orderTotal,orderTaxTotal,orderShippingTotal,orderSubTotal;
@synthesize scrollimage;
@synthesize orderAddress;

@synthesize individuallyUpdated;
@synthesize cancelable;

-(id)init{
    self = [super init];
    if (self) {
    }
    self.orderAddress=[[Address alloc]init];
       return self;
}

-(id)initWithOrderNumber:(NSString *)   oNumber				
             orderStatus:(NSString*)    oStatus
            purchaseDate:(NSString*)    oPurchDate
                   items:(NSArray*)     oItems
              orderTotal:(NSString*)    oGrandTotal
           shippingTotal:(NSString *)   oShipTotal
                subTotal:(NSString*)    oSubTotal
                taxTotal:(NSString*)    oTaxTotal
            isCancelable:(NSString*)    oCancel{
    

    self = [super init];
    self.orderNumber=           [oNumber isKindOfClass:[NSNull class]]?@"":oNumber;
    self.orderStatus=           [oStatus isKindOfClass:[NSNull class]]?@"":oStatus;
    self.purchaseDate =         [oPurchDate isKindOfClass:[NSNull class]]?@"":[oPurchDate substringToIndex:19];
    self.items=                 oItems;
    self.orderShippingTotal=    [oShipTotal doubleValue];
    self.orderSubTotal=         [oSubTotal doubleValue];
    self.orderTaxTotal=         [oTaxTotal doubleValue];
    self.orderTotal=            [oGrandTotal doubleValue];
      scrollimage = [[ScrollingImage alloc]init];
    individuallyUpdated=NO;
  self.cancelable =   [oCancel intValue]==1?YES:NO;
         return self;
}

-(void)organizeImageStack{
     
     //Check if all images are loaded
      int allImagesLoaded=0;
      for( Item* i in self.items){
        if([i.itemImage isKindOfClass:[UIImage class]])
            allImagesLoaded++;
      }
        
      if(allImagesLoaded == [self.items count] && allImagesLoaded!=0){
          NSMutableArray *orderImgs = [[NSMutableArray alloc]init];
          for( Item* i in self.items){
            if(![orderImgs containsObject:i.itemImage])
                        [orderImgs addObject:i.itemImage];
          }
         
     
        self.orderImageStack =[[NSArray alloc]initWithArray: orderImgs];
        scrollimage= [scrollimage initWithImages:orderImageStack];
       
    }
      
}

-(void)addPaymentInfoObject:(NSString *)object{
    self.paymentInfo =object; 
}

-(NSString *)description
{
	NSString *descriptionString=[NSString stringWithFormat:@"OrderNumber: %@ | Purchase Date: %@| OrderStatus: %@| Shipping Total: %.2f | SubTotal : %.2f tax : %.2f  UPDATED: %@| Address:%@ | PaymentInfo %@ | Cancelable %@||\n",
                                                                self.orderNumber,
                                                                self.purchaseDate,
                                                                self.orderStatus,
                                                                self.orderShippingTotal,
                                                                self.orderSubTotal, 
                                                                self.orderTaxTotal, 
                                                                self.individuallyUpdated?@"YES":@"NO",
                                                                self.orderAddress,
                                                                self.paymentInfo,
                                                                self.cancelable?@"YES":@"NO"];
    
        return descriptionString;
}


@end
