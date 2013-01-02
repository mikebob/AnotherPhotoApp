//
//  NSNumber+Filenames.m
//  SmartyPix
//
//  Created by Mike Bobiney on 9/18/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "NSNumber+Filenames.h"

@implementation NSNumber (NSNumber_Filenames)

-(NSString*)filenameStringFromNumber
{
    int len = [[self stringValue] length];
    int zeros = 4-len;
    
    NSMutableString *template = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < zeros; i++) {
        [template appendString:@"0"];
    }
    
    [template appendString:[self stringValue]];
    return template;
}

@end
