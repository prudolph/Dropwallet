//
//  Address.h
//  DropWallet
//
//  Created by Paul Rudolph on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject{

    NSString    *addressID,
                *toName,
                *address1,
                *city,
                *state,
                *zip;

    BOOL        Primary;

}

@property (nonatomic,retain) NSString    *addressID,*toName,*address1,*city,*state,*zip;
@property                    BOOL       primary;



-(id)initWithName:  (NSString *)inName			
         address1:  (NSString*)inAdd1
             city:  (NSString*)inCity
            state:  (NSString*)inState
              zip:  (NSString*)inZip
          primary:  (BOOL)isPrimary
           withID:  (NSString*)addID;

-(BOOL)addressIsEqualto:(Address*)other;
                    
@end
