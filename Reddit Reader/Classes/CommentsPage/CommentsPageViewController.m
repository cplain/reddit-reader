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
#import "Comment.h"

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
    objJson.maxDepth = 10000; //The size of the JSON is so massive that the library's security measure kicks in, this stops it
    
    NSMutableArray *JSONData = (NSMutableArray*)[objJson objectWithString:[request responseString]];
    NSMutableArray *recievedComments = [[NSMutableArray alloc]initWithArray:[[[JSONData objectAtIndex:1] objectForKey:@"data"] objectForKey:@"children"]];
    
    comments = [[NSMutableArray alloc]init];
    Comment *tempComment;
    
    for (int i = 0; i < [recievedComments count]-1; i++)
    {
        tempComment = [[Comment alloc]init];
        tempComment.author = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"author"];
        tempComment.body = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"body"];
        tempComment.upvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"ups"];
        tempComment.downvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"downs"];
        
        if ([[[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"replies"] isKindOfClass:[NSDictionary class]])
        {
            tempComment.comments = [[NSMutableArray alloc]initWithArray:[[[[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"replies"] valueForKey:@"data"] valueForKey:@"children"]];
            [tempComment loadComments];
        }
        [comments addObject:tempComment];
    }
    
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
    
    Comment *comment = [comments objectAtIndex:indexPath.row];
    cell.mainTextView.text = comment.body;
    cell.upvotes.text =  [NSString stringWithFormat:@"%@", comment.upvotes] ;
    cell.downvotes.text = [NSString stringWithFormat:@"%@", comment.downvotes];
    cell.userName.text = comment.author;
    cell.comments = comment.comments;
    
    if(comment.isSubComment)
    {
        cell.mainTextView.backgroundColor = [UIColor greenColor];
    }
    else
    {
        cell.mainTextView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)myTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *tempComment = [comments objectAtIndex:indexPath.row];
    float contentSize = [self getCellContentSize:tempComment];
    return 115.0f - 58.0f + contentSize;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    Comment *comment = [comments objectAtIndex:indexPath.row];
    if (comment == nil) return;
    
    if(comment.isShowingComments)
    {
        for (int i = 0; i < [comment.comments count]-1; i++)
        {
            [comments removeObjectAtIndex:indexPath.row + 1];
        }
    }
    else
    {
        if ([comment.comments count] == 0) return;
        
        for (int i = 0; i < [comment.comments count]-1; i++)
        {
            [comments insertObject:[comment.comments objectAtIndex:i] atIndex:(indexPath.row + 1 + i)];
        }
    }
    comment.isShowingComments = !comment.isShowingComments;  
    [tableView reloadData];
}

-(void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(float)getCellContentSize:(Comment *)tempComment
{
    UIView *tempView = [[UIView alloc]init];
    UITextView *tempTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, (self.tableView.contentSize.width), 5)];
    tempTextView.text = tempComment.body;
    tempTextView.font = [UIFont fontWithName:@"Helvetica" size:14];
    [tempView addSubview:tempTextView];
    return tempTextView.contentSize.height;
}

@end
