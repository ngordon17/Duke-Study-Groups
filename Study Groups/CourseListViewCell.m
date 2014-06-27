//
//  CourseListViewCell.m
//  Study Groups
//
//  Created by Nicholas Gordon on 6/27/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "CourseListViewCell.h"

@implementation CourseListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
