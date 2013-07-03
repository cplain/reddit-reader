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
    
    [self setUpBackButton];
    
    return self;
}

-(IBAction)goToSubreddit:(id)sender
{
    [self.textView endEditing:YES];
    [self.delegate goToSubreddit:self.textView.text withSelection:self.segmentedControl.selectedSegmentIndex];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpBackButton
{
    UIBarButtonItem *backbutton =  [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    
    [backbutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor],UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backbutton;
}

-(void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
