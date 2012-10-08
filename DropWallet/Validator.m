//
//  Validator.m
//  DropWallet
//
//  Created by Paul Rudolph on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Validator.h"

@implementation Validator

@synthesize validationMsgs,statesDict;
@synthesize errorString;
@synthesize validateCC,validateAddress;
-(id)init{
    self = [super init];
    if (self) {
       validationMsgs= [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ValidatorMsgs" ofType:@"plist"]]; 
        NSString *statesPath = [[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"];
        statesDict = [[NSDictionary alloc]initWithContentsOfFile:statesPath];
        errorString=@"";
        
        validateCC=[[CreditCard alloc]init];
        validateAddress=[[Address alloc]init];
           }
    
    return self;
}

-(NSString*)validate:(id)object{
    errorString=@"";
    if ([object isKindOfClass:[Address class]]) {
        validateAddress=(Address*)object;
        
        if([validateAddress.toName    length]==0 ||
           [validateAddress.address1  length]==0 ||
           [validateAddress.city      length]==0 ||
           [validateAddress.state     length]==0 ||
           [validateAddress.toName    length]==0){
            errorString=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"Missing_Field_Valid-Msg"]];
        }
        else{
        
            [self is:validateAddress.toName     aValid:ADD_TONAMETAG];
            [self is:validateAddress.address1   aValid:ADD_ADDRESS1TAG];
            [self is:validateAddress.address2   aValid:ADD_ADDRESS2TAG];
            [self is:validateAddress.city        aValid:ADD_CITYTAG];
            
            if([self is:validateAddress.zip   aValid:ADD_ZIPTAG] &&
               [self is:validateAddress.state aValid:ADD_STATETAG]){
               [self zip:validateAddress.zip AndStateMatch:validateAddress.state];
            }
            
        }
        
        
    }
    else if ([object isKindOfClass:[CreditCard class]]) {
        validateCC=(CreditCard*)object;
        if([validateCC.ccType           length]==0 ||
           [validateCC.cardFirstName    length]==0 ||
           [validateCC.cardLastName     length]==0 ||
           [validateCC.cardNumber       length]==0 ||
           [validateCC.expMonth         length]==0 ||
           [validateCC.expYear          length]==0 ||
           [validateCC.cvv2             length]==0){

            errorString=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"Missing_Field_Valid-Msg"]];
                    }
      
        else{
            [self is:validateCC.ccType          aValid:CCTYPETAG];
            [self is:validateCC.cardFirstName   aValid:CCFNAMETAG];
            [self is:validateCC.cardLastName    aValid:CCLNAMETAG];
            [self is:validateCC.cvv2            aValid:CCCCV2TAG ];
            if(! [self isThis:validateCC.cardNumber andThis:validateCC.cvv2 aValid:validateCC.ccType]){
                  errorString=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"CC#_Gen_Error"]];            
                 
            }
            NSString *saveErrors= [NSString stringWithFormat:@"%@", errorString];
            errorString=[errorString stringByAppendingFormat:saveErrors];
        }
    }
    else
        NSLog(@"No Validation for this object");
   
    
    return errorString;
}
-(NSString*)validateCCForUpdate:(id)object{
    errorString=@"";
    
    if ([object isKindOfClass:[CreditCard class]]) {
        validateCC=(CreditCard*)object;

    if([validateCC.expMonth         length]==0 ||
       [validateCC.expYear          length]==0 ||
       [validateCC.cvv2             length]==0||
       //Address
        //[validateCC.billingAddress.toName    length]==0 ||
        [validateCC.billingAddress.address1  length]==0 ||
        [validateCC.billingAddress.city      length]==0 ||
        [validateCC.billingAddress.state     length]==0 )
        errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Missing_Field_Valid-Msg"]]];
    
    
        [self is:validateCC.expMonth aValid:CCEXPMOTAG];
        [self is:validateCC.expYear aValid:CCEXPYRTAG];
        
        //[self is:validateAddress.toName     aValid:ADD_TONAMETAG];
        //[self is:validateAddress.address1   aValid:ADD_ADDRESS1TAG];
        //[self is:validateAddress.address2   aValid:ADD_ADDRESS2TAG];
        [self is:validateCC.billingAddress.city        aValid:ADD_CITYTAG];
        
        if([self is:validateCC.billingAddress.zip   aValid:ADD_ZIPTAG] &&
           [self is:validateCC.billingAddress.state aValid:ADD_STATETAG]){
        }
    }
    return errorString;
}


#pragma Mark    VALIDATION
-(BOOL)is:(NSString*)input aValid:(int) type{
    BOOL isValid=NO;
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. "];
    charSet = [charSet invertedSet];

    NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    numSet = [numSet invertedSet];
    
    
    switch (type) {
        case CCTYPETAG:isValid=YES;break;
            
        case CCCCV2TAG:{
            //check if ccv2 has only characters
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) 
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"CCV2_Digits"]]];
            else if(!([input length]==3 ||[input length]==4))
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"CCV2_Length"]]];
            else
                isValid=YES;
            break;   
            
        }
            
        case CCEXPMOTAG:{
            //check the length and check for numbers only
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Month_Digits"]]];
            }
            else if([input length]!=2)
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Month_Length"]]];
            else isValid=YES;
            break;}
        
        case CCEXPYRTAG:{
            //check the length and check for numbers only
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Year_Digits"]]];
            }
            else if([input length]!=4)
                errorString=[errorString stringByAppendingFormat: [NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Year_Length"]]];
                else isValid=YES;
            break;}         
            
        case (ADD_TONAMETAG):
        case (CCFNAMETAG):
        case (CCLNAMETAG):
        {
            //Make sure the name is all characters
            NSRange r = [input rangeOfCharacterFromSet:charSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Name_Chars"]]];
            }
          else if ([input length]>32) {
              errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Name_Length"]]];
          }
          else
              isValid=YES;
            break;
        }
            
        case ADD_ADDRESS1TAG:
        case ADD_ADDRESS2TAG:{
            isValid=YES; 
        }
        case ADD_CITYTAG:{    
            isValid=YES; 
            break;
        }
        case ADD_STATETAG:{
                isValid=YES;
            break;
        }
        case ADD_ZIPTAG:{
            NSRange r = [input rangeOfCharacterFromSet:numSet];
            if (r.location != NSNotFound) {
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Zipcode_Digits"]]];
            }
            else if([input length]!=5){
                errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Zipcode_mistype"]]];
            }    
            else
                isValid=YES;
            break;
            
        }
        default:NSLog(@"MISSING VALIDATION FOR FIELD TYPE %d",type);;
            break;
            
            
    }
    
    return  isValid;
}

-(BOOL)zip:(NSString*)zip AndStateMatch:(NSString*)state{
    BOOL zipAndStateROK=NO;
    NSString *zipRangeString=@"";
    //check the zipcode and the state match up

    NSArray *zipArray=   [statesDict allValues];
 
    
    for(NSString *stateNrange in zipArray){
        if([[stateNrange substringToIndex:2] isEqualToString:state])
            zipRangeString = [stateNrange substringFromIndex:3];
    }
  
  NSArray *zipRange= [zipRangeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
              zipAndStateROK=[self zipCode:[[zip substringToIndex:3] intValue] isBetween:[[zipRange objectAtIndex:0]intValue] and:[[zipRange objectAtIndex:1]intValue]];
    
    if (!(zipAndStateROK)) {
        errorString=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Zip_State_Mismatch"]]];        
    }   
    return zipAndStateROK;
}

-(BOOL)zipCode:(int)code isBetween:(int)low and:(int)high{
    
    
    if(high!=-1){
        if((code>=low) && (code<=high))
            return YES;
        else
            return NO;
    }
    else{
        if(code==low)
            return YES;
        else
            return NO;
    }
    
}



-(BOOL)isThis:(NSString*)ccNumber andThis:(NSString*)CCV2 aValid:(NSString*)ccType{
    BOOL ccisValid=NO;

    
    //check number
    if ([ccType isEqualToString:@"American Express"]) {// American Express: length 15, prefix 34 or 37.
        if([ccNumber length]==15){
            if (([[ccNumber substringToIndex:2]intValue]==34) ||
                ([[ccNumber substringToIndex:2]intValue]==37)){ 
                ccisValid= YES;
            }
        }
        else 
            return NO;
        
        
    }
    else if([ccType isEqualToString:@"Discover"]) { // Discover: length 16, prefix 6011
        if(([ccNumber length]==16)&&
           [[ccNumber substringToIndex:4]isEqualToString:@"6011"])
            ccisValid= YES;
        else return NO;
        
    }
    else if([ccType isEqualToString:@"MasterCard"]) {//// Mastercard: length 16, prefix 51-55
        if([ccNumber length]==16){
            if(([[ccNumber substringToIndex:2]intValue]>=51) &&
               ([[ccNumber substringToIndex:2]intValue]<=55)){ 
                ccisValid= YES;
            }
        }
        else 
            return NO;
        
        
    }
    else if([ccType isEqualToString:@"Visa"]) {//// Visa: length 16, prefix 4,
        if(([ccNumber length]==16)&&
           [ccNumber characterAtIndex:0]=='4')
            ccisValid= YES;
        else
            ccisValid= NO;
    }
    else{
        NSLog(@"Dont know this type of card so there is no validation for it.");
        ccisValid=YES;
        
    }
    return ccisValid;
}

-(NSString*)whatIsThisCardType:(NSString*)cardNumber{
    
    // American Express: length 15, prefix 34 or 37.
    if([cardNumber length]==15){
            if (([[cardNumber substringToIndex:2]intValue]==34) ||
                ([[cardNumber substringToIndex:2]intValue]==37)){ 
               return @"American Express";
            }
        }
   // Discover: length 16, prefix 6011
       if([cardNumber length]==16 && [[cardNumber substringToIndex:4]isEqualToString:@"6011"]){
            return @"Discover";
        
        }
                    
   //// Mastercard: length 16, prefix 51-55
    if([cardNumber length]==16){
            if(([[cardNumber substringToIndex:2]intValue]>=51) &&
               ([[cardNumber substringToIndex:2]intValue]<=55)){ 
                return @"Mastercard";
            }
        }
               
    
   //// Visa: length 16, prefix 4,
       if(([cardNumber length]==16)&&
           [cardNumber characterAtIndex:0]=='4')
            return @"Visa";
           return @"";

    
    
}

#pragma mark - NewPasswordValidation

-(NSString*)checkThisOldPassword:(NSString*)oldPassword
                 currentPassword:(NSString*)currentPassword
                     newPassword:(NSString*)newPass 
                  andRetypedPass:(NSString*) retypePass{
    
NSString * error=@"";
    //check that the password entered matches the stored password.

    if ([currentPassword isEqual:oldPassword]) {
        
        
        //check the new password and the confirmation are equal
        if ([newPass isEqual:retypePass]) {
            //check that the old password and the new password are not the s
            if ([currentPassword isEqual:newPass]) 
           error=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"New_Old_Same"]]];  
            
            //check that the new passwords fit validation requirements
            NSLog(@"%@",newPass);
            if (([newPass length]<3||[newPass length]>23))
                error=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Password_Length"]]];  
            
        }
        else{
            error=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"Password_Mismatch"]]];       
        }
    }
    else{
        error=[errorString stringByAppendingFormat:[NSString stringWithFormat:@"%@\n",[validationMsgs objectForKey:@"CurrentPass_Mismatch"]]];     
    }
    
    return error;


}

-(NSString*)isThisValidUsername:(NSString *)uname andPassWord:(NSString*)pass{
        NSString * error=@"";
    // username:Length>0, no spaces, contains an @ and a "."
    //pass>0

    if(!uname.length>0)
           error=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"Missing_Uname"]];     
   
 
    if ([uname rangeOfString:@" "].location != NSNotFound ||
        [uname rangeOfString:@"."].location == NSNotFound || 
        [uname rangeOfString:@"@"].location == NSNotFound) 
        error=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"Valid_Email"]];  
    
    if(pass.length<3||pass.length>23)
        error=[errorString stringByAppendingFormat:[validationMsgs objectForKey:@"Pass_Length"]];  
    
    return error;
}

@end
