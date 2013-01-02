//
//  SPXFrameScroller.h
//  SmartyPix
//
//  Created by Mike Bobiney on 8/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHideNavigationBar @"SPXHideNavigationBar"
#define kShowNavigationBar @"SPXShowNavigationBar"

@interface SPXFrameScroller : UIScrollView<UIScrollViewDelegate>
{
    BOOL enableZoom;
    BOOL isZoomed;
    BOOL isStatusBarVisible;
    
    @private
    UIImageView *imageToBeFramed;
}

@property (nonatomic) BOOL enableZoom;
@property (nonatomic) BOOL isZoomed;
@property (readonly, nonatomic, retain) UIImageView *imageToBeFramed;

-(id)initWithFrame:(CGRect)frame;
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center;

@end
