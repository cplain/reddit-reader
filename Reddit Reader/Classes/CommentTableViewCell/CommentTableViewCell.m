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
@synthesize comments;
@synthesize containerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

@end
