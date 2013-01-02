//
//  FramingViewController.m
//  SmartyPix
//
//  Created by Mike Bobiney on 8/9/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "FramingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SmartyPixViewController.h"

@implementation FramingViewController {
    
}

@synthesize scrollView, framedPicFilename;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(id)init {
    self = [super init];
    if(self) {
        appDelegate = APP_DELEGATE;
    }
    return self;
}

- (id)initWithSPXFrame:(SPXFrame *)myframe andSelectedImage:(UIImage *)theImage
{
    self = [self init];
    if (self) {
        frameImageView = [[UIImageView alloc] initWithImage: theImage];
        scrollView = [[SPXFrameScroller alloc] initWithFrame:CGRectMake(5, 5, 310, 395)];
        scrollView.contentSize = scrollView.frame.size;
        //selectedImage.frame = CGRectMake(0, 0, availSize.width, availSize.height);

        [self.scrollView addSubview:frameImageView];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:myframe];
        
        framedPicFilename = myframe.imageFilename;
        
        [self setupToolbarsAsModal:NO];
    }
    return self;
}

- (id)initWithSavedImage:(UIImage *)theImage andFramedPicFilename:(NSString*)filename
{
    self = [self init];
    if (self) {
        
        framedPicFilename = filename;
        [framedPicFilename retain];
        
        frameImageView = [[UIImageView alloc] initWithImage: theImage];
        
        scrollView = [[SPXFrameScroller alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        scrollView.contentSize = CGSizeMake(320, 480);
        //selectedImage.frame = CGRectMake(0, 0, availSize.width, availSize.height);
        [self.scrollView addSubview:frameImageView];
        [self.view addSubview:self.scrollView];
        [self setupToolbarsAsModal:YES];
//        self.scrollView.enableZoom = NO;
        [self showNavBar];
        [self performSelector:@selector(hideNavBar) withObject:nil afterDelay:2];
        
    }
    return self;
}

-(void)setupToolbarsAsModal:(BOOL)isModal
{
    UIBarButtonItem *deleteBtn;
    UIBarButtonItem	*flex;
    UIBarButtonItem	*doneBtn;
    UIBarButtonItem	*cancelBtn;
    
    NSArray *toolbarItems;
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Keep" style:UIBarButtonItemStyleDone target:self action:@selector(saveFramedPicture)];
    self.navigationItem.rightBarButtonItem = bbi;
    [bbi release];    
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *actionBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)] autorelease];

    deleteBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePressed:)] autorelease];        
    flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    doneBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModalView)] autorelease];
    cancelBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(trashPic)] autorelease];    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"glossy-red.png"] forState:UIControlStateNormal];
    [button setTitle:@"Discard" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor grayColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [button addTarget:self action:@selector(trashPic) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (isModal) {    
        toolbarItems = [NSArray arrayWithObjects:actionBarItem, flex, doneBtn, flex, deleteBtn, nil];
    } else {
        toolbarItems = [NSArray arrayWithObjects:flex, cancelBtn, nil];
    }
        
    [toolbar setItems:toolbarItems animated:YES];        

    [self.view addSubview:toolbar];    
    
    [cancelBtn release];
}

-(void)deletePressed:(UIButton *)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Nevermind"destructiveButtonTitle:@"Really Delete?" otherButtonTitles: nil];
    
    sheet.tag = 100;
    
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    [sheet release];
}


-(void)trashPic {
    NSString *filePath = [USER_PICS_DIRECTORY stringByAppendingFormat:@"%@.png", framedPicFilename];
    NSFileManager *fileMgr = [NSFileManager defaultManager];       
    NSError *error;    
    if ([fileMgr removeItemAtPath:filePath error:&error] != YES) {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPastPics object:nil];
    
    [self closeModalView];
}

-(void)closeModalView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveFramedPicture
{
    NSFileManager *fileManager= [NSFileManager defaultManager]; 
    if([fileManager fileExistsAtPath:USER_PICS_DIRECTORY] == NO) {
        if([fileManager createDirectoryAtPath:USER_PICS_DIRECTORY withIntermediateDirectories:YES attributes:nil error:NULL] == NO) {
            NSLog(@"Error: Create folder failed %@", USER_PICS_DIRECTORY);
        }
    }


    NSString  *pngPath = [NSString stringWithFormat:@"%@%@.png",
                          USER_PICS_DIRECTORY, [UserPrefsHandler UserPicFileName]];

    if([UIImagePNGRepresentation([self imageFromScreenShot]) writeToFile:pngPath atomically:YES]) {
        [UserPrefsHandler setPicCount:[UserPrefsHandler PicCount]+1];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPastPics object:nil];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)hideNavBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        toolbar.transform = CGAffineTransformMakeTranslation(0, toolbar.frame.size.height);
    }];
}

-(void)showNavBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.15 animations:^(void) {
        toolbar.transform = CGAffineTransformMakeTranslation(0, -toolbar.frame.size.height);
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:        
                [self trashPic];
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self hideNavBar];
                UIImageWriteToSavedPhotosAlbum([self imageFromScreenShot], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                break;
            case 1:
                [self hideNavBar];
                [self sendEmail];
                break;
            default:
                break;
        }
    }
}

-(UIImage*)imageFromScreenShot
{
    [self hideNavBar];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(appDelegate.window.bounds.size);
    }
    
    [appDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    [self showNavBar];
    
    return image;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) { 
        NSLog(@"Error: %@", error);        
    }
}

#pragma mark - View lifecycle -

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavBar) name:kHideNavigationBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBar) name:kShowNavigationBar object:nil];        
}

-(void)viewDidDisappear:(BOOL)animated
{
//    [self showNavBar];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;    
    
    //CGPoint scrollPosition = CGPointMake(scrollView.contentOffset.x / 2, scrollView.contentOffset.y / 2);
    //savedZoomState = [scrollView zoomRectForScrollView:scrollView withScale:scrollView.zoomScale withCenter:scrollPosition];
   
    //savedScrollCenterPoint = CGPointMake(scrollView.contentOffset.x + 320/2, scrollView.contentOffset.y + 480/2);
    savedScrollCenterPoint = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    savedZoomScale = scrollView.zoomScale;
    
//    NSLog(@"x:%f / y:%f", savedScrollCenterPoint.x, savedScrollCenterPoint.y);
//    NSLog(@"%f", savedZoomScale);
}

-(void)viewWillAppear:(BOOL)animated
{
    CGRect scrollRect = [scrollView zoomRectForScrollView:self.scrollView withScale:savedZoomScale withCenter:savedScrollCenterPoint];

//    NSLog(@"x:%f / y:%f", scrollRect.origin.x, scrollRect.origin.y);
//    NSLog(@"%f", savedZoomScale);

    if(!CGRectIsEmpty(scrollRect))
    {
        //[scrollView zoomToRect:scrollRect animated:NO];
        [scrollView zoomToRect:CGRectMake(scrollRect.origin.x, scrollRect.origin.y, 320, 480) animated:NO];
    } else {
        
        
        float minzoomx = self.scrollView.frame.size.width / self.scrollView.imageToBeFramed.frame.size.width;
        float minzoomy = self.scrollView.frame.size.height / self.scrollView.imageToBeFramed.frame.size.height;
        self.scrollView.minimumZoomScale = MAX(minzoomx, minzoomy);
        self.scrollView.maximumZoomScale = 3.0f;
        
//        CGRect rect = self.scrollView.imageToBeFramed.frame;
//        [self.scrollView zoomToRect:CGRectMake(0, 0, rect.size.width, rect.size.height) animated:NO];
        
        [self.scrollView zoomToRect:frameImageView.frame animated:NO];
    }
    
    //[scrollView zoomToRect:savedZoomState animated:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
     
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(showActionSheet)];
   self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
                                               
//    temporaryBarButtonItem.title = @"<<";
//    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
//    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
//     CGRect zrect = [self zoomRectForScrollView:self withScale:0.6 withCenter:touchPoint];
//     [self zoomToRect:zrect animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

#pragma Mark - Compose Email -

-(void)sendEmail {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
	
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIGraphicsBeginImageContext(appDelegate.window.bounds.size);
    [appDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    [controller setSubject:@"Check out my picture!"];
    
    NSString *attachedFilename = [NSString stringWithFormat:@"SmartyPic_%@.jpg", framedPicFilename];
    [controller addAttachmentData:data mimeType:@"image/jpg" fileName:attachedFilename];

    [self presentViewController:controller animated:YES completion:nil];
	[controller release];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.scrollView zoomToRect:frameImageView.frame animated:NO];
}

-(void)showActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to device", @"Email", nil];
    
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    [sheet release];
}

-(void)dealloc
{
    [scrollView release];
    [frameImageView release];
    [toolbar release];
    [super dealloc];
}

@end