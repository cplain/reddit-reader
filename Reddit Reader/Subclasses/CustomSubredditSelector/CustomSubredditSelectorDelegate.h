//
//  NSObject_CustomSubredditSelectorDelegate.h
//  Reddit Reader
//
//  Created by Coby Plain on 28/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomSubredditSelectionDelegate <NSObject>
@required
-(void)goToSubreddit:(NSString*)subredditName withSelection:(NSInteger)selection;
@end
