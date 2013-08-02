//
//  ViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//
#define REUSE_IDENTIFIER @"ThreadTableViewCell"

#import "MainPageViewController.h"
#import "CommentsPageViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ThreadTableViewCell.h"
#import "Thread.h"

@interface MainPageViewController ()
@end

@implementation MainPageViewController

NSMutableArray *mainDataArray;
NSMutableArray *threads;
NSString *subreddit = @"";
NSInteger selectedSegment = 0;

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSubredditSelector];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self recieveJSON];
}

-(void)setUpSubredditSelector
{
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"subreddit" style:UIBarButtonItemStyleBordered target:self action:@selector(subredditSelectorTapped:)];
    [buttonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

-(void)subredditSelectorTapped:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        [self handlePopup:sender];
    
    else
        [self newWindowSelector];
}

-(void)handlePopup:(id)sender
{
    if (_subredditSelector == nil)
    {
        _subredditSelector = [[SubredditSelector alloc] initWithNibName:@"SubredditSelector" bundle:nil];
        _subredditSelector.delegate = self;
    }
    if (_subredditSelectorPopover == nil)
    {
        _subredditSelectorPopover = [[UIPopoverController alloc] initWithContentViewController:_subredditSelector];
        [_subredditSelectorPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                                          permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        [_subredditSelectorPopover dismissPopoverAnimated:YES];
        _subredditSelectorPopover = nil;
    }
}

-(void)newWindowSelector
{
    SubredditSelector *selector = [[SubredditSelector alloc] initWithNibName:@"SubredditSelector" bundle:nil];
    selector.delegate = self;
    [self.navigationController pushViewController:selector animated:YES];
}

-(void)recieveJSON
{
    NSString *url;
    
    if ([subreddit isEqualToString:@""])
        url = [NSString stringWithFormat:@"http://www.reddit.com/%@.json", [self getViewCat]];
    else
        url = [NSString stringWithFormat:@"http://www.reddit.com/r/%@/%@.json" , subreddit, [self getViewCat]];
    
    NSLog(@"URL: %@", url);    

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(NSString *)getViewCat
{
    switch (selectedSegment) {
        case 0:
            return @"hot";
        
        case 1:
            return @"top";
            
        case 2:
            return @"new";
            
        default:
            return @"hot";
    }
}

-(void)populateList
{
    NSDictionary *tempDict;
    Thread *tempThread;
    threads = [NSMutableArray array];
    
    for(int i = 0; i < [mainDataArray count]; i++)
    {
        tempThread = [[Thread alloc] init];
        tempDict = [[mainDataArray objectAtIndex:i]valueForKey:@"data"];
        
        tempThread.threadName = [tempDict valueForKey:@"title"];
        tempThread.upvotes = [tempDict valueForKey:@"ups"];
        tempThread.downvotes = [tempDict valueForKey:@"downs"];
        tempThread.comments = [tempDict valueForKey:@"num_comments"];
        tempThread.url = [NSString stringWithFormat:@"%@.json",[tempDict valueForKey:@"url"]];
        
        [threads addObject:tempThread];
    }
    
    [self.tableView reloadData];
    
    if ([subreddit isEqualToString:@""])
        self.title = @"reddit.com";
    else
        self.title = [NSString stringWithFormat:@"/r/%@", subreddit];
    
    if ([threads count] == 0)
        [self showRefreshDialog];
    
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && [_delegate needsContent] )
        [self selectFirstRow];
}

-(void)showRefreshDialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Looks like we didn't recieve anything from that subreddit"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Retry", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 1:
            [self recieveJSON];
            break;
            
        default:
            break;
    }
}

-(void)selectFirstRow
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"threads size: %d", [threads count]);
    return [threads count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadTableViewCell *cell = (ThreadTableViewCell *)[myTableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:REUSE_IDENTIFIER owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Thread *thread = [threads objectAtIndex:indexPath.row];
    cell.mainLabel.text = thread.threadName;
    cell.upvotes.text = [NSString stringWithFormat:@"%@", thread.upvotes];
    cell.downvotes.text = [NSString stringWithFormat:@"%@", thread.downvotes];
    cell.comments.text = [NSString stringWithFormat:@"comments(%@)", thread.comments];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    Thread *thread = [threads objectAtIndex:indexPath.row];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if (_delegate)
        {
            [_delegate selectedSubreddit:thread];
        }
    }
    else
    {
        CommentsPageViewController *comments = [[CommentsPageViewController alloc]initWithNibName:@"CommentsPageViewController" bundle:nil];
        comments.thread = thread;
        [self.navigationController pushViewController:comments animated:YES];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    SBJsonParser *objJson = [[SBJsonParser alloc] init];
    NSDictionary *data = (NSDictionary*)[objJson objectWithString:[request responseString]];
    mainDataArray = [[data valueForKey:@"data"] valueForKey:@"children"];

    [self populateList];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

-(void)goToSubreddit:(NSString*)subredditName withSelection:(NSInteger)selection
{
    subreddit = subredditName;
    selectedSegment = selection;
    [self recieveJSON];
    
    if (_subredditSelectorPopover) {
        [_subredditSelectorPopover dismissPopoverAnimated:YES];
        _subredditSelectorPopover = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
