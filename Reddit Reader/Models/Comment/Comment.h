//
//  Comment.h
//  Reddit Reader
//
//  Created by Coby Plain on 5/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *upvotes;
@property (nonatomic, retain) NSString *downvotes;
@property (nonatomic, retain) NSString *additonalInfo;
@property (nonatomic, retain) NSMutableArray *comments;
@property (nonatomic) BOOL isShowingComments;
@property (nonatomic) BOOL isSubComment;

-(void)loadComments;

@end
