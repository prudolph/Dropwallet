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
            address2,
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
         address2:  (NSString*)inAdd2
             city:  (NSString*)inCity
            state:  (NSString*)inState
              zip:  (NSString*)inZip
          primary:  (BOOL)isPrimary
           withID:  (NSString*)addID{
    
    
    self = [super init];
    self.toName =    [self checkInData:inName];
    
    self.address1=   [self checkInData:inAdd1];
    
    self.address2=   [self checkInData:inAdd2];
    
    self.city =      [self checkInData:inCity];    
    
    self.state =     [self checkInData:inState];
    
    self.zip =      [self checkInData:inZip];
    self.primary=   isPrimary;
    
    self.addressID=addID;
    return self;
}

-(NSString *)checkInData:(NSString*)inString{
    if([inString isKindOfClass:[NSNull class]] || [inString isEqualToString:@"(null)"]|| inString ==nil){
        return @"";
    }
    else {
        return [ inString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Address:|PRIMary %@ |%@| %@| %@| %@, %@ %@ |  ",self.primary?@"YES":@"NO",self.toName,self.address1,address2,
self.city,
self.state,
self.zip];
}
    
-(BOOL)addressIsEqualto:(Address*)other{
    if(
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
-(NSString*) convertToAbv:(NSString*)st{
    NSString *statesPath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
    NSDictionary* statesDict = [[NSDictionary alloc]initWithContentsOfFile:statesPath];
    
 return (NSString*)[[statesDict objectForKey:st] substringToIndex:2];
            
}


-(NSData*)asDataForUpdate{

    if([self.state length]>2)
        self.state=[self convertToAbv:self.state];
  
    NSString *addressBody=[NSString stringWithFormat:@"address1=%@&city=%@&state=%@&zip=%@&postalName=%@&primary=%@",self.address1,self.city,self.state,self.zip,self.toName,self.primary?@"true":@"false"];
    
       if(!(([self.address2 isEqualToString:@"(null)"]) ||
       ([self.address2 isKindOfClass:[NSNull class]]) ||
       ([self.address2 isEqual:NULL])||
       ([self.address2 isEqual:@""])||
       (self.address2 ==NULL)
       )){
        addressBody=[addressBody stringByAppendingFormat:@"&address2=%@",self.address2];
    }
    NSLog(@"ADDRESS AS DATA FOR PUT %@",addressBody);
    return [addressBody dataUsingEncoding:NSUTF8StringEncoding];
}
@end
