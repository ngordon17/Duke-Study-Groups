//
//  StudyGroupListViewCell.h
//  Study Groups
//
//  Created by Nicholas Gordon on 7/3/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyGroupListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myCreatedBy;
@property (weak, nonatomic) IBOutlet UILabel *myCreatedOn;
@property (weak, nonatomic) IBOutlet UILabel *myType;
@property (weak, nonatomic) IBOutlet UILabel *myPublic;
@property (weak, nonatomic) IBOutlet UILabel *myLocation;
@property (weak, nonatomic) IBOutlet UILabel *myMeetingTimesLeftCol;
@property (weak, nonatomic) IBOutlet UILabel *myMeetingTimesRightCol;
@property (weak, nonatomic) IBOutlet UILabel *myCapacity;

@end
