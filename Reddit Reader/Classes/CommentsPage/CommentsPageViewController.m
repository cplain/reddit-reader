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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadingIndicator];
    [self loadThread];
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
    [myAlertView show];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.commentThreadUrl];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //Do something here
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}
@end
