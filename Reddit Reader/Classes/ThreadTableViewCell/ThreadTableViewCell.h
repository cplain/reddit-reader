//
//  CustomTableViewCell.h
//  Reddit Reader
//
//  Created by Coby Plain on 27/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UILabel *mainLabel;
@property(strong, nonatomic) IBOutlet UILabel *upvotes;
@property(strong, nonatomic) IBOutlet UILabel *downvotes;
@property(strong, nonatomic) IBOutlet UILabel *comments;

@end
