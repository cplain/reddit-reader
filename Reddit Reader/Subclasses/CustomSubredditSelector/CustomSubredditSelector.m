//
//  CustomSubredditSelector.m
//  Reddit Reader
//
//  Created by Coby Plain on 28/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "CustomSubredditSelector.h"

@implementation CustomSubredditSelector

@synthesize textView;
@synthesize segmentedControl;
@synthesize delegate;

-(IBAction)goToSubreddit:(id)sender
{
    [self.delegate goToSubreddit:self.textView.text withSelection:self.segmentedControl.selectedSegmentIndex];
    [self.textView endEditing:YES];
}

@end
