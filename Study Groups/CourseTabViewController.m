//
//  CourseTabViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 7/5/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "CourseTabViewController.h"
#import "StudyGroupListViewController.h"
#import "CourseInformationViewController.h"

@interface CourseTabViewController ()

@end

@implementation CourseTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    StudyGroupListViewController *sglvc = [self viewControllers][0];
    CourseInformationViewController *civc = [self viewControllers][1];
    sglvc.myCourse = _myCourse;
    civc.myCourse = _myCourse;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
