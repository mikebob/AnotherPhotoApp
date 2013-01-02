//
//  SmartyPixAppDelegate.h
//  SmartyPix
//
//  Created by Mike Bobiney on 7/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartyPixAppDelegate : NSObject <UIApplicationDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSArray *frameData;

@end
