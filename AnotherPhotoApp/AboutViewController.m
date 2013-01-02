//
//  AboutViewController.m
//  SmartyPix
//
//  Created by Mike Bobiney on 9/14/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "AboutViewController.h"
#import "TSMiniWebBrowser.h"

@implementation AboutViewController

- (id)init {
    self = [super init];
    if (self) {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    }
    return self;
}

-(IBAction)launchFeedback {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject: @"support@domain.com"]];
    [controller setSubject:@"App Feedback"];
    [self presentViewController:controller animated:YES completion:nil];
    [controller release];
}

- (IBAction)openWebsite:(id)sender {
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:@"http://www.tapthroughapps.com"]];
    webBrowser.showURLStringOnActionSheetTitle = YES;
    webBrowser.showPageTitleOnTitleBar = YES;
    // webBrowser.showActionButton = YES;
    webBrowser.showReloadButton = YES;
    webBrowser.isModal = YES;
    // webBrowser.barStyle = UIBarStyleBlack;
    [self presentViewController:webBrowser animated:YES completion:nil];
    
    [webBrowser release];
}

- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self becomeFirstResponder];
    
    if(result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"Message sent." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] autorelease];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
