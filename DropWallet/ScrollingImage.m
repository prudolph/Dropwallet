//
//  ScrollingImage.m
//  imageScroll
//
//  Created by Paul Rudolph on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollingImage.h"

@implementation ScrollingImage


@synthesize start,direction;
@synthesize curPos,kNumImages;
@synthesize kScrollObjWidth,kScrollObjHeight;
@synthesize timer;



-(id)initWithImages:(NSArray*)images{
    self = [super init];
    if (self) {
       
 
        curPos=0;
        start=NO;
        
        kScrollObjHeight= 95.0;
        kScrollObjWidth	= 100.0;
        kNumImages		= [images count];

        self.backgroundColor =[UIColor whiteColor];
        [self setCanCancelContentTouches:NO];        
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.layer.cornerRadius = 11;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
        self.scrollEnabled = YES;
        
        // pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
        // if you want free-flowing scroll, don't set this property.
        self.pagingEnabled = NO;
     
        [self loadImages:images];
        [self layoutScrollImages];	// now place the photos in serial layout within the scrollview
        self.showsHorizontalScrollIndicator=NO;

    }
    
    return self;
}

-(void)loadImages:(NSArray*)images{
    // load all the images from our bundle and add them to the scroll view
    NSUInteger i;
    for (i = 0; i <[images count]; i++)
    {
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        
        // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
        CGRect rect = imageView.frame;
        rect.size.height = kScrollObjHeight;
        rect.size.width = kScrollObjWidth-15;
        imageView.frame = rect;
        imageView.tag = i+1;	// tag our images for later use when we place them in serial fashion
        [self addSubview:imageView];
        
      
        
    }


}
- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [self subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[self setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [self bounds].size.height)];
}


-(void)scroll{
    
  
    curPos=((int)(self.contentOffset.x)/kScrollObjWidth)*kScrollObjWidth;
   
    if(kNumImages>1){
        //went to far to the right
        if(curPos==(kNumImages-1)*kScrollObjWidth ||curPos>(kNumImages-1)*kScrollObjWidth){
            direction=NO;
            curPos=kScrollObjWidth*(kNumImages-1);
        }
        //went to far the left
        if(curPos<=0){
            direction=YES;
            curPos =0;
        }
        if(direction){
            curPos+=kScrollObjWidth;
            [self setContentOffset:CGPointMake((curPos), 0) animated:YES];
            curPos=self.contentOffset.x;
        }
        else{
            curPos-=kScrollObjWidth;
            [self setContentOffset:CGPointMake((curPos), 0) animated:YES];
            curPos=self.contentOffset.x;        
        }
        }
    else{
        [self setBounces:YES];
        [timer invalidate];
    }
        
   }


-(IBAction)startScrollcycle:(id)sender{

    start=start? NO:YES;
    
    
    if(start){
        if(![self isDragging])
            timer = [NSTimer scheduledTimerWithTimeInterval:1.35 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
        
    }
    else
        [timer invalidate]; 

}
-(BOOL)isScrolling{
    return start;
}



@end
