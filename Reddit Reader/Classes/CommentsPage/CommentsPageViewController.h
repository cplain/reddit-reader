//
//  CommentsPageViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditSelectionDelegate.h"

@interface CommentsPageViewController : UIViewController <SubredditSelectionDelegate, UISplitViewControllerDelegate>

@property (nonatomic, retain) NSURL *commentThreadUrl;
@property (nonatomic, retain) IBOutlet UITextView *tempDisplay;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIBarButtonItem *myBarButtonItem;

@end
