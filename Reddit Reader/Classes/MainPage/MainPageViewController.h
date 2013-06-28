//
//  ViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditSelectionDelegate.h"
#import "CustomSubredditSelector.h"
#import "CustomSubredditSelectorDelegate.h"

@interface MainPageViewController : UIViewController <CustomSubredditSelectionDelegate>

@property(nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<SubredditSelectionDelegate> delegate;
@property (nonatomic, strong) CustomSubredditSelector *subredditSelector;
@property (nonatomic, strong) UIPopoverController *subredditSelectorPopover;

@end
