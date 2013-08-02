//
//  Thread.h
//  Reddit Reader
//
//  Created by Coby Plain on 28/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thread : NSObject

@property(nonatomic, retain) NSString *threadName;
@property(nonatomic, retain) NSString *upvotes;
@property(nonatomic, retain) NSString *downvotes;
@property(nonatomic, retain) NSString *comments;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *imageURL;

@end
