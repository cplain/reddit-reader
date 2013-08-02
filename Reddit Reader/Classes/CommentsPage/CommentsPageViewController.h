//
//  CommentsPageViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditSelectionDelegate.h"
#import "Thread.h"

@interface CommentsPageViewController : UIViewController <SubredditSelectionDelegate, UISplitViewControllerDelegate>

@property (nonatomic, retain) Thread *thread;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIBarButtonItem *myBarButtonItem;

@property (nonatomic, retain) IBOutlet UITextView *threadName;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

-(IBAction)topCommentTapped:(id)sender;

@end
