//
//  RootViewController.h
//  SmartyPix
//
//  Created by Mike Bobiney on 7/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FramingViewController.h"
#import "FrameChooserViewController.h"
#import "AboutViewController.h"
#import "BSPreviewScrollView.h"

@interface SmartyPixViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, BSPreviewScrollViewDelegate> {
    
    BOOL isAboutVisible;
    
    FramingViewController *framing;
    FrameChooserViewController *frameChoose;
    UIImagePickerController *imagePickerController;
    UIButton *infoBtn;
    AboutViewController *aboutVC;
    CGRect pagerDefaultSize;
    
    BSPreviewScrollView *previewScroller;
    NSArray *scrollPages;
    
}
-(IBAction)aboutThisApp:(id)sender;
-(IBAction)captureFromCamera:(id)sender;
-(IBAction)captureFromPhotoLibrary:(id)sender;
-(void)loadPastPics;
-(void)loadPicModally:(UIButton*)sender;

@property (nonatomic, retain) NSArray *scrollPages;
@property (nonatomic, retain) IBOutlet BSPreviewScrollView *previewScroller;

@property (nonatomic, retain) IBOutlet UITableView *tvFunctions;
@property (nonatomic, retain) UIImageView *selectedImage;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end
