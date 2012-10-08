//
//  ScrollingImage.h
//  imageScroll
//
//  Created by Paul Rudolph on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ScrollingImage : UIScrollView{

 
    
    NSTimer *timer;
    BOOL start,direction;
    
    CGFloat kScrollObjHeight,kScrollObjWidth;

    NSUInteger curPos,kNumImages;
}


@property (nonatomic) BOOL start,direction;
@property (nonatomic) NSUInteger curPos,kNumImages;
@property (nonatomic) CGFloat kScrollObjHeight,kScrollObjWidth;
@property (nonatomic,retain )NSTimer *timer;

-(id)initWithImages:(NSArray*)images;
-(IBAction)startScrollcycle:(id)sender;
-(void)layoutScrollImages;
-(void)loadImages:(NSArray*)images;

@end
