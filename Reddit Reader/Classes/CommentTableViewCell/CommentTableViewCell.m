//
//  CommentTableViewCell.m
//  Reddit Reader
//
//  Created by Coby Plain on 1/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Comment.h"
@implementation CommentTableViewCell

@synthesize mainTextView;
@synthesize userName;
@synthesize additionalDetail;
@synthesize upvotes;
@synthesize downvotes;
@synthesize hasComments;
@synthesize containerView;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self highlightView:selected];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [self highlightView:highlighted];
}

-(void)highlightView:(BOOL)selected
{
    if(selected && self.hasComments)
    {
        [self.highlightField setBackgroundColor:[UIColor colorWithRed:(5.0f/255.0f) green:(111.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f]];
    }
    else
    {
        [self.highlightField setBackgroundColor:[UIColor colorWithRed:(225.0f/255.0f) green:(225.0f/255.0f) blue:(225.0f/255.0f) alpha:1.0f]];
    }
}
@end
