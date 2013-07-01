//
//  CommentTableViewCell.h
//  Reddit Reader
//
//  Created by Coby Plain on 1/07/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UILabel *mainLabel;
@property(strong, nonatomic) IBOutlet UILabel *upvotes;
@property(strong, nonatomic) IBOutlet UILabel *downvotes;
@property(strong, nonatomic) IBOutlet UILabel *userName;
@property(strong, nonatomic) IBOutlet UILabel *additionalDetail;

@end
