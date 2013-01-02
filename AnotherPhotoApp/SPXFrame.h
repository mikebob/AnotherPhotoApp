//
//  SPXFrame.h
//  SmartyPix
//
//  Created by Mike Bobiney on 8/12/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPXFrame : UIView
{
    NSString *title;
    NSURL *imageURL;
    UIImage *image;
    NSString *imageFilename;
    NSString *hexColor;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *imageFilename;

- (id)initWithDictionary:(NSDictionary*)dict andFrame:(CGRect)frame;

@end
