//
//  CustomSubredditSelector.m
//  Reddit Reader
//
//  Created by Coby Plain on 28/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "SubredditSelector.h"

@implementation SubredditSelector

@synthesize textView;
@synthesize segmentedControl;
@synthesize delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
        self.contentSizeForViewInPopover = self.view.frame.size;
    
    return self;
}

-(IBAction)goToSubreddit:(id)sender
{
    [self.textView endEditing:YES];
    [self.delegate goToSubreddit:self.textView.text withSelection:self.segmentedControl.selectedSegmentIndex];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
