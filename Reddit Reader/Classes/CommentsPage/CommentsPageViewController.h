//
//  CommentsPageViewController.h
//  Reddit Reader
//
//  Created by Coby Plain on 21/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsPageViewController : UIViewController

@property (nonatomic, retain) NSURL *commentThreadUrl;
@property (nonatomic, retain) IBOutlet UITextView *tempDisplay;

@end
