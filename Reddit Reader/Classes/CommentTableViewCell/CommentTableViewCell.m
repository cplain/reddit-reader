//
//  CommentTableViewCell.m
//  Reddit Reader
//
//  Created by Coby Plain on 1/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#define REUSE_IDENTIFIER @"CommentTableViewCell"

#import "CommentTableViewCell.h"
#import "Comment.h"
@implementation CommentTableViewCell

@synthesize mainTextView;
@synthesize userName;
@synthesize additionalDetail;
@synthesize upvotes;
@synthesize downvotes;
@synthesize commentsTableView;
@synthesize sideLabel;
@synthesize comments;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)refresh
{
    [self.commentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.commentsTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[myTableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:REUSE_IDENTIFIER owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    cell.mainTextView.text = comment.body;
    cell.upvotes.text =  [NSString stringWithFormat:@"%@", comment.upvotes] ;
    cell.downvotes.text = [NSString stringWithFormat:@"%@", comment.downvotes];
    cell.userName.text = comment.author;
    cell.comments = comment.comments;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)myTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *tempComment = [self.comments objectAtIndex:indexPath.row];
    UIView *tempView = [[UIView alloc]init];
    UITextView *tempTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, (self.commentsTableView.contentSize.width), 5)];
    tempTextView.text = tempComment.body;
    tempTextView.font = [UIFont fontWithName:@"Helvetica" size:14];
    [tempView addSubview:tempTextView];
    
    return 115.0f - 58.0f + tempTextView.contentSize.height;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    //Current winning idea is to have a UITableView inside the cell
    //Tapping this would hide that view and cause a reload of the table
    //That means that in the cell height calc method i will need to decide whether or not I include the height of the UITableView
    //as such I am going to need a flag in the Comment class that determines whether or not to do this
    //It also means my code in the cell will have to handle the management of it's own table (it could get quite complex)
    //I must also look into what should be default hidden (all, nothing or some sort of medium)
    
    //If this works, I'm really liking it -> must check the code I just wrote works first
    
    CommentTableViewCell *cell = (CommentTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    comment.isShowingComments = !comment.isShowingComments;
    [comments replaceObjectAtIndex:indexPath.row withObject:comment];
    [cell refresh];
    [tableView reloadData];
}

@end
