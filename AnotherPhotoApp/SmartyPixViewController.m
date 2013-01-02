//
//  RootViewController.m
//  SmartyPix
//
//  Created by Mike Bobiney on 7/23/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "SmartyPixViewController.h"
#import "ResultsViewController.h"
#import "SPXFrame.h"
#import "SPXPreviewButton.h"

@implementation SmartyPixViewController
@synthesize previewScroller;
@synthesize scrollPages;
@synthesize tvFunctions, selectedImage, imagePickerController;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Another Photo App";
        framing = [[FramingViewController alloc] init];
        imagePickerController = [[UIImagePickerController alloc] init];
        aboutVC = [[AboutViewController alloc] init];                

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [btn addTarget:self action:@selector(aboutThisApp:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        self.navigationItem.rightBarButtonItem = bbi;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPastPics) name:kLoadPastPics object:nil];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPastPics];   
}

-(void)loadPastPics
{    
    NSFileManager *fileMgr = [NSFileManager defaultManager];       
    
    CGRect rect = previewScroller.frame;

    [previewScroller removeFromSuperview], previewScroller = nil;

    self.scrollPages = [fileMgr contentsOfDirectoryAtPath:USER_PICS_DIRECTORY error:nil];
    
    NSString *emptyItemPlaceholderPath = [[NSBundle mainBundle] pathForResource:@"empty-library-notice" ofType:@"png"];
    NSString *copyToLocation = [USER_PICS_DIRECTORY stringByAppendingString:@"empty-library-notice.png"];

    if ([self.scrollPages count] == 0) {
        [fileMgr createDirectoryAtPath:USER_PICS_DIRECTORY withIntermediateDirectories:YES attributes:nil error:NULL];
        [fileMgr copyItemAtPath:emptyItemPlaceholderPath toPath:copyToLocation error:nil];
    } else if ([fileMgr fileExistsAtPath:copyToLocation] && [self.scrollPages count] > 1) {
        [fileMgr removeItemAtPath:copyToLocation error:nil];
    }
    
    self.scrollPages = [fileMgr contentsOfDirectoryAtPath:USER_PICS_DIRECTORY error:nil];
    
    previewScroller = [[BSPreviewScrollView alloc] initWithFrameAndPageSize:rect pageSize:CGSizeMake(160, 220)];
    previewScroller.delegate = self;
    previewScroller.backgroundColor = [UIColor colorWithHexString:@"#89f4ff"];
    
    [self.view insertSubview:previewScroller atIndex:0]; // important that this view is behind others
}

#pragma mark -
#pragma mark BSPreviewScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index
{
	// Note that the images are actually smaller than the image view frame, each image
	// is 210x280. Images are centered and because they are smaller than the actual 
	// view it creates a padding between each image. 
	CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, 160, 220);
    int numberOfPages = [self.scrollPages count];
    
    SPXPreviewButton *btn = [[SPXPreviewButton alloc] initWithFrame:imageViewFrame];
	btn.userInteractionEnabled = YES;
    
    NSString *filename = [self.scrollPages objectAtIndex: numberOfPages - (index + 1)];
    //btn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    [btn setImage:[UIImage imageWithContentsOfFile:[USER_PICS_DIRECTORY stringByAppendingString: filename]] forState:UIControlStateNormal];
    btn.tag = [filename integerValue]; // Tags in reverse order
    
    if(![filename hasPrefix:@"empty"]) {
        [btn addTarget:self action:@selector(loadPicModally:) forControlEvents:UIControlEventTouchUpInside];
    }
    
	return btn;
}

-(int)itemCount:(BSPreviewScrollView*)scrollView
{
	// Return the number of pages we intend to display
	return [self.scrollPages count];
}

-(void)loadPicModally:(UIButton*)sender
{
    
    NSNumber *numb = [NSNumber numberWithInt:sender.tag];
    
    NSString *filename = [NSString stringWithString:[numb filenameStringFromNumber]];
    UIImage *img = [UIImage imageWithContentsOfFile:[USER_PICS_DIRECTORY stringByAppendingFormat:@"%@.png", filename]];
    
    FramingViewController *frameVC = [[FramingViewController alloc] initWithSavedImage:img andFramedPicFilename:filename];
    [self presentViewController:frameVC animated:YES completion:nil];
    [frameVC release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

-(IBAction)aboutThisApp:(id)sender;
{    
    [self presentViewController:aboutVC animated:YES completion:nil];
}

-(IBAction)captureFromCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.delegate = self;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"NO CAMERA FOUND");
        return;
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);;
}

-(IBAction)captureFromPhotoLibrary:(id)sender
{
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *tmpimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    frameChoose = [[FrameChooserViewController alloc] init];
    frameChoose.image = tmpimage;
    [self.navigationController pushViewController:frameChoose animated:YES];        
}

-(void)didReceiveMemoryWarning
{
    frameChoose = [[FrameChooserViewController alloc] init];
}

- (void)dealloc
{
    [imagePickerController release];
    [framing release];
    [tvFunctions release];
    [frameChoose release];
    [infoBtn release];
    [aboutVC release];
    [previewScroller release];
    [scrollPages release];
    
    [super dealloc];
}

@end
