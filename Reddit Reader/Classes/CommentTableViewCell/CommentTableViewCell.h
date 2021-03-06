//
//  CommentTableViewCell.h
//  Reddit Reader
//
//  Created by Coby Plain on 1/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UITextView *mainTextView;
@property(strong, nonatomic) IBOutlet UILabel *upvotes;
@property(strong, nonatomic) IBOutlet UILabel *downvotes;
@property(strong, nonatomic) IBOutlet UILabel *userName;
@property(strong, nonatomic) IBOutlet UILabel *additionalDetail;
@property(nonatomic) BOOL hasComments;

@property(strong, nonatomic)IBOutlet UILabel *highlightField;
@property(strong, nonatomic) IBOutlet UIView *containerView;

@end
