//
//  FrameChooserViewController.h
//  SmartyPix
//
//  Created by Mike Bobiney on 8/15/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPXFrame.h"

@interface FrameChooserViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UIImage *image;
    
    @private
    SmartyPixAppDelegate *appDelegate;
    UITableView *tableView;
    SPXFrame *spxframe;
    NSArray *sortedFrameList;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) SPXFrame *spxframe;
@property (nonatomic, retain) UITableView *tableView;

@end
