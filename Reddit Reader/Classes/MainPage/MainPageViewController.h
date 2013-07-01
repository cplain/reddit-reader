//
//  ViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditSelectionDelegate.h"
#import "SubredditSelector.h"
#import "SubredditSelectorDelegate.h"

@interface MainPageViewController : UIViewController <SubredditSelectionDelegate>

@property(nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<SubredditSelectionDelegate> delegate;
@property (nonatomic, strong) SubredditSelector *subredditSelector;
@property (nonatomic, strong) UIPopoverController *subredditSelectorPopover;

@end
