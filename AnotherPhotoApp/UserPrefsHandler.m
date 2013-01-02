//
//  UserPrefsHandler.m
//  SmartyPix
//
//  Created by Mike Bobiney on 9/12/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "UserPrefsHandler.h"

#define PIC_COUNT @"PICCOUNT"

@implementation UserPrefsHandler

+(void)setPicCount:(NSInteger)count
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:count forKey:PIC_COUNT];
    [defaults synchronize];    
}

+(NSInteger)PicCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:PIC_COUNT];
}

+(NSString*)UserPicFileName
{
    NSNumber *numb = [NSNumber numberWithInteger:[self PicCount]];
    return [numb filenameStringFromNumber];
}


@end
