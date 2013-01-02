//
//  UserPrefsHandler.h
//  SmartyPix
//
//  Created by Mike Bobiney on 9/12/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPrefsHandler : NSObject

+(void)setPicCount:(NSInteger)count;
+(NSInteger)PicCount;
+(NSString*)UserPicFileName;

@end
