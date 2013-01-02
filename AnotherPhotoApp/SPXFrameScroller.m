//
//  SPXFrameScroller.m
//  SmartyPix
//
//  Created by Mike Bobiney on 8/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "SPXFrameScroller.h"

@implementation SPXFrameScroller

@synthesize imageToBeFramed, enableZoom, isZoomed;

-(UIImageView *)imageToBeFramed
{
    return [self.subviews objectAtIndex:0];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.autoresizesSubviews = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        self.delegate = self;
        self.enableZoom = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //if(self.isZooming || self.isDragging) return;
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageToBeFramed.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageToBeFramed.frame = frameToCenter;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return the first subview of the scroll view
    return (enableZoom) ? self.imageToBeFramed : nil;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    UITouch *touch = [[event allTouches] anyObject]; 
    if ([touch tapCount] == 1) 
    {
        if (isStatusBarVisible) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kHideNavigationBar object:nil];
            isStatusBarVisible = NO;
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowNavigationBar object:nil];
            isStatusBarVisible = YES;
        }

    }
    else if ([touch tapCount] == 2) 
    { 
        if(!isZoomed){ 
            CGRect rect = [self.imageToBeFramed bounds];
            [self zoomToRect:rect animated:YES];
            isZoomed = YES;
        }else { 
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint touchPoint = [touch locationInView:self.imageToBeFramed];
            CGRect zrect = [self zoomRectForScrollView:self withScale:0.6 withCenter:touchPoint];
            [self zoomToRect:zrect animated:YES];
            isZoomed = NO;
        } 
    } 
} 

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(void)dealloc
{
    [imageToBeFramed release];
    [super dealloc];
}

@end
