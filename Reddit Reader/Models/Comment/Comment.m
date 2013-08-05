//
//  Comment.m
//  Reddit Reader
//
//  Created by Coby Plain on 5/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize comments;

- (void)loadComments
{
    if (self.comments == nil || [self.comments count] == 0) return;
    
    NSMutableArray *recievedComments = self.comments;
    self.comments = [[NSMutableArray alloc]init];
    
    Comment *tempComment;
    for (int i = 0; i < [recievedComments count]; i++)
    {
        tempComment = [[Comment alloc]init];
        tempComment.author = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"author"];
        tempComment.body = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"body"];
        tempComment.upvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"ups"];
        tempComment.downvotes = [[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"downs"];
        tempComment.indent = self.indent + 5;        
        if ([[[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"replies"] isKindOfClass:[NSDictionary class]])
        {
            tempComment.comments = [[NSMutableArray alloc]initWithArray:[[[[[recievedComments objectAtIndex:i] valueForKey:@"data"] valueForKey:@"replies"] valueForKey:@"data"] valueForKey:@"children"]];
            [tempComment loadComments];
            if (tempComment.comments != nil)
                tempComment.isShowingComments = YES;

        }
        [comments addObject:tempComment];
    }
}

-(NSMutableArray *)getAllComments
{
    if (self.comments == nil || [self.comments count] == 0) return nil;
    
    NSMutableArray *tempComments = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [comments count]-1; i++)
    {
        [tempComments addObject:[comments objectAtIndex:i]];
        [tempComments addObjectsFromArray:[[comments objectAtIndex:i] getAllComments]];
    }
    
    return tempComments;
}

@end
