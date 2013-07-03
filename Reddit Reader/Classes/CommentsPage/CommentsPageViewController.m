//
//  CommentsPageViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#define REUSE_IDENTIFIER @"CommentTableViewCell"

#import "CommentsPageViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "CommentTableViewCell.h"

@interface CommentsPageViewController ()

@end

@implementation CommentsPageViewController

@synthesize tableView;

UIAlertView *myAlertView;
NSMutableArray *comments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadingIndicator];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [self setUpBackButton];
        [self loadThread];
    }
    else
    {
        [self.myBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor blackColor],UITextAttributeTextColor,
                                            [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
        
        [self.popover presentPopoverFromBarButtonItem:self.myBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpBackButton
{
    UIBarButtonItem *backbutton =  [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    
    [backbutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor],UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backbutton;
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
    self.threadName.text = self.thread.threadName;
    
    [myAlertView show];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.thread.url]];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    SBJsonParser *objJson = [[SBJsonParser alloc] init];
    objJson.maxDepth = 10000;
    
    NSMutableArray *data = (NSMutableArray*)[objJson objectWithString:[request responseString]];
    comments = [[NSMutableArray alloc]initWithArray:[[[data objectAtIndex:1] objectForKey:@"data"] objectForKey:@"children"]];
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

-(void)selectedSubreddit:(Thread *)selectedThread
{    
    if (_popover != nil)
        [_popover dismissPopoverAnimated:YES];

    self.thread = selectedThread;
    [self loadThread];
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

-(BOOL)needsContent
{
    return self.thread == nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Comments size: %d", [comments count]);
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[myTableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:REUSE_IDENTIFIER owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *comment = [[comments objectAtIndex:indexPath.row] valueForKey:@"data"];
    
    cell.mainTextView.text = [comment valueForKey:@"body"];
    cell.upvotes.text = [NSString stringWithFormat:@"%@", [comment valueForKey:@"ups"]];
    cell.downvotes.text = [NSString stringWithFormat:@"%@", [comment valueForKey:@"downs"]];
    cell.userName.text = [comment valueForKey:@"author"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    //this will need some planning
}

-(void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
