//
//  Comment.m
//  Reddit Reader
//
//  Created by Coby Plain on 5/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize author;
@synthesize body;
@synthesize upvotes;
@synthesize downvotes;
@synthesize additonalInfo;
@synthesize comments;
@synthesize isShowingComments;
@synthesize internalTableSize;

- (void)loadComments
{
    NSMutableArray *recievedComments = self.comments;
    
    self.comments = [[NSMutableArray alloc]init];
    Comment *tempComment;
    
    for (int i = 0; i < [recievedComments count]-1; i++)
    {
        tempComment = [[Comment alloc]init];
        tempComment.author = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"author"];
        tempComment.body = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"body"];
        tempComment.upvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"ups"];
        tempComment.downvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"downs"];
        NSMutableDictionary *dataDict = [[recievedComments objectAtIndex:i] valueForKey:@"data"];
        if ([[dataDict valueForKey:@"replies"] isKindOfClass:[NSDictionary class]])
        {
            tempComment.comments = [[NSMutableArray alloc]initWithArray:[[[dataDict valueForKey:@"replies"] valueForKey:@"data"] valueForKey:@"children"]];
            [tempComment loadComments];
        }
        [comments addObject:tempComment];
    }
}

@end
