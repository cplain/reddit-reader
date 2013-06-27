//
//  ViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubredditSelectionDelegate.h"

@interface MainPageViewController : UIViewController

@property(nonatomic, retain)IBOutlet UITableView *tableView;
@property(nonatomic, retain)IBOutlet UITextField *textView;
@property(nonatomic, retain)IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) id<SubredditSelectionDelegate> delegate;

- (IBAction) goToSubreddit:(id)sender;

@end
