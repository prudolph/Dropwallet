//
//  Address.m
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Address.h"

@implementation Address

@synthesize  addressID,toName,
            address1,
            city,
            state,
            zip;
@synthesize primary;


-(id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(id)initWithName:  (NSString *)inName			
         address1:  (NSString*)inAdd1
             city:  (NSString*)inCity
            state:  (NSString*)inState
              zip:  (NSString*)inZip
          primary:  (BOOL)isPrimary
           withID:  (NSString*)addID{
    
    
    self = [super init];
    
    self.toName =    [inName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.address1=   [inAdd1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.city =      [inCity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.state =     [inState stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.zip =       [inZip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.primary=   isPrimary;
    self.addressID=addID;
    return self;
}




-(NSString *)description
{
    return [NSString stringWithFormat:@"Address: \n%@\n %@\n %@, %@ %@\n\n",self.toName,self.address1,
self.city,
self.state,
self.zip];
}
    
-(BOOL)addressIsEqualto:(Address*)other{
    if([self.toName     isEqualToString:other.toName]     &&
       [self.address1   isEqualToString:other.address1]   &&
       [self.city       isEqualToString:other.city]       &&
       [self.state      isEqualToString:other.state]      &&
       [self.zip        isEqualToString:other.zip]){
              return YES;
    }

    else{
       
        return NO;
    }
}
@end
