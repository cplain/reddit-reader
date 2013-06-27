//
//  SubredditSelectionDelegate.h
//  Reddit Reader
//
//  Created by Coby Plain on 27/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubredditSelectionDelegate <NSObject>
@required
-(void)selectedSubreddit:(NSURL *)selectedCommentThreadUrl;
@end
