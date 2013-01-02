//
//  SPXPreviewButton.m
//  SmartyPix
//
//  Created by Mike Bobiney on 9/22/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "SPXPreviewButton.h"

@implementation SPXPreviewButton

@synthesize previewImage;

- (id)init
{
    self = [super init];
    if (self) {
//        self.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    
    return self;
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    self.previewImage = image;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

//    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;
    //    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);    
    CGContextSetShadow(context, CGSizeMake(5, 5), 3);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(5, 5, 150, 210));

    CGContextRestoreGState(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokeRect(context, CGRectMake(5, 5, 150, 210));

    [self.previewImage drawInRect:CGRectMake(10, 10, 140, 200)];    
    
    //CGContextRestoreGState(context);
    
}

@end
