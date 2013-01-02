//
//  ResultsViewController.h
//  SmartyPix
//
//  Created by Mike Bobiney on 7/31/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultsViewControllerDelegate;

@interface ResultsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    id <ResultsViewControllerDelegate> delegate;
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) id<ResultsViewControllerDelegate> delegate;

@end

@protocol ResultsViewControllerDelegate
@required
-(void)didCaptureImage:(UIImage *)image;
@end
