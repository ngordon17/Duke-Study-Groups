//
//  CourseListViewController.h
//  Study Groups
//
//  Created by Nicholas Gordon on 6/27/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseListViewController : UITableViewController
@property (strong, nonatomic) NSString *mySubject;
@property (strong, nonatomic) NSArray *myCourseList;

@end
