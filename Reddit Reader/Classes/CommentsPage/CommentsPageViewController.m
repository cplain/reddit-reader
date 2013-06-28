//
//  CommentsPageViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "CommentsPageViewController.h"
#import "ASIHTTPRequest.h"

@interface CommentsPageViewController ()

@end

@implementation CommentsPageViewController

UIAlertView *myAlertView;
@synthesize commentThreadUrl;
@synthesize tempDisplay;
@synthesize tempTitleDisplay;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadingIndicator];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        [self loadThread];
    else
        [self.popover presentPopoverFromBarButtonItem:self.myBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpLoadingIndicator
{
    myAlertView = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"\n"
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil, nil];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.center = CGPointMake(139.5, 75.5);
    [myAlertView addSubview:loading];
    [loading startAnimating];
}

-(void)loadThread
{
    tempTitleDisplay.text = self.threadName;
    [myAlertView show];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.commentThreadUrl];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    NSString *responseString = [request responseString];
    [self.tempDisplay setText:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

-(void)selectedSubreddit:(NSString *)threadName withURL:(NSURL *)selectedCommentThreadUrl
{    
    if (_popover != nil)
        [_popover dismissPopoverAnimated:YES];

    self.commentThreadUrl = selectedCommentThreadUrl;
    self.threadName = threadName;
    [self loadThread];
}

-(BOOL)needsContent
{
    return self.threadName == nil;
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    self.popover = pc;
    self.myBarButtonItem = barButtonItem;
    self.myBarButtonItem.title = @"Threads";
    [self.navigationItem setLeftBarButtonItem:self.myBarButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    _popover = nil;
}

@end
