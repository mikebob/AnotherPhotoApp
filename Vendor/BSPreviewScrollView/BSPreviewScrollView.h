//
//  BSPreviewScrollView.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class BSPreviewScrollView;

@protocol BSPreviewScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index;
-(int)itemCount:(BSPreviewScrollView*)scrollView;

@end


@interface BSPreviewScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id<BSPreviewScrollViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<BSPreviewScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;

- (void)didReceiveMemoryWarning;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;

@end
