//
//  ResultsViewController.m
//  SmartyPix
//
//  Created by Mike Bobiney on 7/31/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "ResultsViewController.h"

@implementation ResultsViewController

@synthesize delegate, imagePickerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *tmpimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.delegate didCaptureImage:tmpimage];
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [self dismissModalViewControllerAnimated:YES];
//    [imageView setImage:image];
//}

-(void)dealloc
{
    [imagePickerController release];
    [super dealloc];
}

@end
