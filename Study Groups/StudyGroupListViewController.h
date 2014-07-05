//
//  StudyGroupListViewController.h
//  Study Groups
//
//  Created by Nicholas Gordon on 7/3/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyGroupListViewController : UITableViewController
@property (nonatomic, strong) NSArray *myGroupList;
@property (nonatomic, strong) NSString *myCourse;
@property (strong, nonatomic) UIActivityIndicatorView *myActivityIndicator;

@end
