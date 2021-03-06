//
//  CommentsPageViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#define REUSE_IDENTIFIER @"CommentTableViewCell"
#define SUBTLE_OFFSET ((int)7)
#define ANIMATION_DURATION ((float)0.5)

#import "CommentsPageViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "CommentTableViewCell.h"
#import "Comment.h"
#import "AnimatedGif.h"

@interface CommentsPageViewController ()

@end

@implementation CommentsPageViewController

@synthesize tableView;

UIAlertView *myAlertView;
NSMutableArray *comments;
UIImageView *gifView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadingIndicator];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        self.threadName.font = [UIFont fontWithName:@"Helvetica" size:16];
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
    [self positionViews];
    [self configScrollViewToPanImages];
    [self hideShadow:nil];
    [myAlertView show];
    [self sendRequest];
}

-(void)positionViews
{
    self.threadName.text = self.thread.threadName;
    self.containerView.frame      = CGRectMake(self.containerView.frame.origin.x,
                                               self.containerView.frame.origin.y,
                                               self.containerView.frame.size.width,
                                               self.threadName.contentSize.height + SUBTLE_OFFSET);
    
    self.tableView.frame          = CGRectMake(self.tableView.frame.origin.x,
                                               self.containerView.frame.origin.y + self.containerView.frame.size.height - SUBTLE_OFFSET,
                                               self.tableView.frame.size.width,
                                               self.view.frame.size.height - self.containerView.frame.size.height + SUBTLE_OFFSET);
    
    self.imageContainerView.frame = CGRectMake(self.imageContainerView.frame.origin.x,
                                               -(self.view.frame.size.height - self.containerView.frame.size.height + SUBTLE_OFFSET),
                                               self.imageContainerView.frame.size.width,
                                               self.view.frame.size.height - self.containerView.frame.size.height + SUBTLE_OFFSET);
}

-(void)configScrollViewToPanImages
{
    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
    [self.scrollview setMinimumZoomScale:1.0];
    [self.scrollview setMaximumZoomScale:4.0];
}

-(void)sendRequest
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.thread.url]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self processComments:[self parseJSON:request]];
    [self.tableView reloadData];
    [self showImage];
}

-(NSMutableArray *)parseJSON:(ASIHTTPRequest *)request
{
    SBJsonParser *objJson = [[SBJsonParser alloc] init];
    objJson.maxDepth = 10000; //The size of the JSON is so massive that the library's security measure kicks in, this stops it
    NSMutableArray *JSONData = (NSMutableArray*)[objJson objectWithString:[request responseString]];
    return [[NSMutableArray alloc]initWithArray:[[[JSONData objectAtIndex:1] objectForKey:@"data"] objectForKey:@"children"]];
}

-(void)processComments:(NSMutableArray *)recievedComments
{
    comments = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [recievedComments count]-1; i++)
    {
        Comment *tempComment = [self loadComment:[recievedComments objectAtIndex:i]];
        [comments addObject:tempComment];
        [comments addObjectsFromArray:[tempComment getAllComments]];
    }
}

-(Comment *)loadComment:(NSDictionary *)commentDict
{
    Comment *tempComment;
    tempComment = [[Comment alloc]init];
    tempComment.author = [[commentDict valueForKey:@"data"] valueForKey:@"author"];
    tempComment.body = [[commentDict valueForKey:@"data"] valueForKey:@"body"];
    tempComment.upvotes = [[commentDict valueForKey:@"data"] valueForKey:@"ups"];
    tempComment.downvotes = [[commentDict valueForKey:@"data"] valueForKey:@"downs"];
    tempComment.indent = 0;
    
    if ([[[commentDict valueForKey:@"data"] valueForKey:@"replies"] isKindOfClass:[NSDictionary class]])
    {
        tempComment.comments = [[NSMutableArray alloc]initWithArray:[[[[commentDict valueForKey:@"data"] valueForKey:@"replies"] valueForKey:@"data"] valueForKey:@"children"]];
        [tempComment loadComments];
        if (tempComment.comments != nil)
            tempComment.isShowingComments = YES;
    }
    return tempComment;
}

-(void)showImage
{
    if (gifView != nil)
        [gifView removeFromSuperview];
    
    if ([[self.thread.imageURL substringWithRange:NSMakeRange(self.thread.imageURL.length - 4, 4)]isEqualToString:@".gif"])
        [self loadGif];
    else
        [self loadImage];
    
    [self.imageLabel setHidden:(self.imageView.image == nil)];
}

-(void)loadGif
{
    gifView = [AnimatedGif getAnimationForGifAtUrl: [NSURL URLWithString:self.thread.imageURL]];
    [self.imageContainerView addSubview:gifView];
    [self.imageView setHidden:YES];
    [self showAnimation];
}

-(void)loadImage
{
    //Reddit can just give straight links to imgur.com - when this happens, to get the actual image you need to add a filetype
    if (![[self.thread.imageURL substringWithRange:NSMakeRange(self.thread.imageURL.length - 4, 4)]isEqualToString:@".jpg"])
        self.imageView.image = [self fetchImage:[NSString stringWithFormat:@"%@.jpg", self.thread.imageURL]];
    else
        self.imageView.image = [self fetchImage:self.thread.imageURL];
    
    [self.imageView setHidden:NO];
    
    if (self.imageView.image != nil)
        [self showAnimation];
}

-(UIImage *)fetchImage:(NSString *)urlString
{
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [[UIImage alloc] initWithData:data];
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
    
    cell.containerView.frame = CGRectMake(cell.frame.origin.x + comment.indent, cell.containerView.frame.origin.y, cell.frame.size.width - comment.indent, cell.containerView.frame.size.height);
    cell.mainTextView.text = comment.body;
    cell.upvotes.text =  [NSString stringWithFormat:@"%@", comment.upvotes] ;
    cell.downvotes.text = [NSString stringWithFormat:@"%@", comment.downvotes];
    cell.userName.text = comment.author;
    cell.hasComments = comment.comments != nil;
    return cell;
}

- (CGFloat)tableView:(UITableView *)myTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellContentHeight:indexPath];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    Comment *comment = [comments objectAtIndex:indexPath.row];
    if (comment == nil) return;
    
    if(comment.isShowingComments)
        [self collapse:comment atIndex:indexPath.row];
    else
        [self expand:comment atIndex:indexPath.row];
    
    comment.isShowingComments = !comment.isShowingComments;  
    [tableView reloadData];
}

-(void)collapse:(Comment*)comment atIndex:(int)index
{
    for (int i = 0; i < [comment.comments count]-1; i++)
    {
        [self removeSubComments:[comments objectAtIndex:index+1] atPosition:index+1];
        [comments removeObjectAtIndex:index + 1];
    }
}

-(void)expand:(Comment *) comment atIndex:(int)index
{
    if ([comment.comments count] == 0 || comment.comments == nil) return;
    
    for (int i = 0; i < [comment.comments count]-1; i++)
        [comments insertObject:[comment.comments objectAtIndex:i] atIndex:(index + 1 + i)];
}

-(void)removeSubComments:(Comment *)comment atPosition:(NSUInteger)currentPosition
{
    if(comment.isShowingComments)
    {
        for (int i = 0; i < [comment.comments count]-1; i++)
        {
            [self removeSubComments:[comments objectAtIndex:currentPosition+1]atPosition:currentPosition+1];
            [comments removeObjectAtIndex:currentPosition + 1];
        }
        comment.isShowingComments = NO;
    }
}

-(void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(float)getCellContentHeight:(NSIndexPath *)indexPath
{    
    return 115.0f - 58.0f + [self sizeOfComment:[comments objectAtIndex:indexPath.row]];
}

-(int)sizeOfComment:(Comment *) comment
{
    UIView *tempView = [[UIView alloc]init];
    UITextView *tempTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, (self.tableView.contentSize.width), 5)];
    tempTextView.text = comment.body;
    tempTextView.font = [UIFont fontWithName:@"Helvetica" size:14];
    [tempView addSubview:tempTextView];
    return tempTextView.contentSize.height;
}

-(IBAction)topCommentTapped:(id)sender
{
    if (self.imageContainerView.frame.origin.y == -self.imageContainerView.frame.size.height && self.imageView.image != nil)
        [self showAnimation];
    else
        [self hideAnimation];
}

-(void) showAnimation
{
    [self showShadow];
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.imageContainerView.frame = CGRectMake(self.imageContainerView.frame.origin.x,
                                                                    self.containerView.frame.origin.y + self.containerView.frame.size.height - SUBTLE_OFFSET,
                                                                    self.imageView.frame.size.width,
                                                                    self.imageContainerView.frame.size.height);
                     }];
    [self performSelector:@selector(restoreTouch:) withObject:nil afterDelay:(NSTimeInterval)ANIMATION_DURATION];
}

-(void)showShadow
{
    [self.shadowLabel setHidden:NO];
    self.tableView.userInteractionEnabled = NO;
}

-(void)restoreTouch:(NSObject *)object
{
    self.view.userInteractionEnabled = YES;
}

-(void) hideAnimation
{
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.imageContainerView.frame = CGRectMake(self.imageContainerView.frame.origin.x,
                                                                    -self.imageContainerView.frame.size.height,
                                                                    self.imageContainerView.frame.size.width,
                                                                    self.imageContainerView.frame.size.height);
                     }];
    
    [self performSelector:@selector(hideShadow:) withObject:nil afterDelay:(NSTimeInterval)ANIMATION_DURATION];
}

-(void)hideShadow:(NSObject *)object
{
    [self.shadowLabel setHidden:YES];
    self.tableView.userInteractionEnabled = YES;
    [self restoreTouch:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
{
    CGPoint contentOffset = [self.scrollview contentOffset];
    CGSize  contentSize   = [self.scrollview contentSize];
    CGSize  containerSize = [self.imageView frame].size;
    
    self.scrollview.maximumZoomScale = self.scrollview.maximumZoomScale / scale;
    self.scrollview.minimumZoomScale = self.scrollview.minimumZoomScale / scale;
    
    [self.scrollview setZoomScale:1.0f];
    
    [self.scrollview setContentOffset:contentOffset];
    [self.scrollview setContentSize:contentSize];
    [self.imageView setFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
}

@end
