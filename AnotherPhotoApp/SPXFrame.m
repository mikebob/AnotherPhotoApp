//
//  SPXFrame.m
//  SmartyPix
//
//  Created by Mike Bobiney on 8/12/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "SPXFrame.h"

@implementation SPXFrame

@synthesize title, imageURL, image, imageFilename;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict andFrame:(CGRect)frame;
{
    self = [self initWithFrame:frame];
    if (self) {
//        self.title  = [obj valueForKey:@"Title"];
//        self.imageURL    = [NSURL URLWithString: [obj valueForKey:@"URL"]];
//        self.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.imageURL]];
        
        self.imageFilename = [NSString stringWithFormat:@"%@.png", [dict valueForKey:@"Image"]];
        UIImage *img = [UIImage imageNamed:imageFilename];
        hexColor = [dict valueForKey:@"BorderColor"];
        self.image = img;
        self.title = [dict valueForKey:@"Title"];
        
    }
    return self;
}

-(void)setupImageFrame {
//    SmartyPixAppDelegate *appDelegate = [(SmartyPixAppDelegate*)[UIApplication sharedApplication] delegate];  
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHexString:hexColor] CGColor]);
    CGContextSetLineWidth(context, 10.0);
    CGRect rect = CGRectMake(0.0, 0.0, 320.0, 480.0);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 400, 310, 75)];
    imgView.image = self.image;
    [self addSubview:imgView];
    [imgView release];
    
    //[self.image drawInRect:CGRectMake(0, 395, 320, 75)];
    //    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setupImageFrame];
    
    // Add Watermark
    //[[UIImage imageNamed:@"watermark.png"] drawAtPoint:CGPointMake(255, 435) blendMode:kCGBlendModeNormal alpha:0.5];
}

@end
