//
//  FramingViewController.h
//  SmartyPix
//
//  Created by Mike Bobiney on 8/9/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPXFrame.h"
#import <MessageUI/MessageUI.h>
#import "SPXFrameScroller.h"

@interface FramingViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>
{
    @private
    NSString *framedPicFilename;
    SmartyPixAppDelegate *appDelegate;
    
    @public
    SPXFrameScroller *scrollView;
    UIImageView *frameImageView;
    UIToolbar *toolbar;

    CGPoint savedScrollCenterPoint;
    float savedZoomScale;
    
    int picCount;
}

@property (nonatomic, retain) SPXFrameScroller *scrollView;
@property (nonatomic, retain) NSString *framedPicFilename;

- (id)initWithSPXFrame:(SPXFrame *)myframe andSelectedImage:(UIImage *)theImage;
- (id)initWithSavedImage:(UIImage *)theImage andFramedPicFilename:(NSString*)filename;
-(void)showActionSheet;
-(void)sendEmail;
-(void)hideNavBar;
-(void)showNavBar;
-(void)saveFramedPicture;
-(UIImage*)imageFromScreenShot;
-(void)setupToolbarsAsModal:(BOOL)isModal;
-(void)trashPic;
-(void)closeModalView;
-(void)deletePressed:(UIButton *)sender;
@end


