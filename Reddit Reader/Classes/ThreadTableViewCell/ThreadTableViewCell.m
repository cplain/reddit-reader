//
//  CustomTableViewCell.m
//  Reddit Reader
//
//  Created by Coby Plain on 27/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "ThreadTableViewCell.h"

@implementation ThreadTableViewCell

@synthesize mainLabel;
@synthesize upvotes;
@synthesize downvotes;
@synthesize comments;
@synthesize background;

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
    if(selected)
    {
        [self.background setBackgroundColor:[UIColor colorWithRed:(5.0f/255.0f) green:(111.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f]];
        [self.mainLabel setTextColor:[UIColor colorWithRed:(215.0f/255.0f) green:(215.0f/255.0f) blue:(215.0f/255.0f) alpha:1.0f]];
        [self.comments setTextColor:[UIColor colorWithRed:(215.0f/255.0f) green:(215.0f/255.0f) blue:(215.0f/255.0f) alpha:1.0f]];
    }
    else
    {
        [self.background setBackgroundColor:[UIColor whiteColor]];
        [self.mainLabel setTextColor:[UIColor blackColor]];
        [self.comments setTextColor:[UIColor colorWithRed:(50.0f/255.0f) green:(79.0f/255.0f) blue:(133.0f/255.0f) alpha:1.0f]];
    }
}

@end


