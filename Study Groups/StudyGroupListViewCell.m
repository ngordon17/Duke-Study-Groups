//
//  StudyGroupListViewCell.m
//  Study Groups
//
//  Created by Nicholas Gordon on 7/3/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "StudyGroupListViewCell.h"

@implementation StudyGroupListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setCapacity: (int) capacity size: (int) size {
    double ratio = size*1.0 / capacity;
    if (ratio < 0.5) {[_myCapacity setTextColor: [UIColor colorWithRed: 0 green: 1 blue: 0 alpha: 0]];}
    else if (ratio < 0.75) {[_myCapacity setTextColor: [UIColor colorWithRed: 1 green: 0.5 blue: 0 alpha: 0]];}
    else {[_myCapacity setTextColor: [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0]];}
    _myCapacity.text = [NSString stringWithFormat:@"%d/%d", (int) size, (int) capacity];
}

@end
