//
//  SmartyPixAppDelegate.m
//  SmartyPix
//
//  Created by Mike Bobiney on 7/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "SmartyPixAppDelegate.h"
#import "SmartyPixViewController.h"

@implementation SmartyPixAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize frameData = _frameData;

#define KSessionEventTimer @"KSessionEventTimer"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SmartyPixViewController *smartyPixVC = [[SmartyPixViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController: smartyPixVC];
    [smartyPixVC release];

    self.window.rootViewController = self.navigationController;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FrameList" ofType:@"plist"];
    _frameData = [[[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"Frames"] retain];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
