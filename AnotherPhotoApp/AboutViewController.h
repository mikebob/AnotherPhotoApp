//
//  AboutViewController.h
//  SmartyPix
//
//  Created by Mike Bobiney on 9/14/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate>

-(IBAction)launchFeedback;
- (IBAction)openWebsite:(id)sender;
- (IBAction)closeModal:(id)sender;

@end
