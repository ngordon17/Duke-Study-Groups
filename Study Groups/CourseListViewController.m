//
//  CourseListViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 6/27/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "CourseListViewController.h"
#import "SBJson.h"
#import "CourseListViewCell.h"
#import "CourseTabViewController.h"
#import "DatabaseCore.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _myActivityIndicator.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
    _myActivityIndicator.layer.cornerRadius = 10.0f;
    _myActivityIndicator.frame = CGRectMake(0, 0, 55, 55);
    _myActivityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0));
    [self.view addSubview: _myActivityIndicator];
    
    [self getCourseList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Activity Indicator
-(void) showActivityIndicator {
    [_myActivityIndicator setHidden:false];
    [_myActivityIndicator startAnimating];
}

-(void) hideActivityIndicator {
    [_myActivityIndicator setHidden:true];
    [_myActivityIndicator stopAnimating];
}

#pragma mark - Retrieve data

-(void) getCourseListCompletionHandler: (NSURLResponse *)response data:(NSData *)data error:(NSError *) error {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    [self hideActivityIndicator];
    
    if ([httpResponse statusCode] < 200 || [httpResponse statusCode] >= 300) {
        NSLog(@"Error: %@ || Status Code: %d", error, [httpResponse statusCode]);
        return;
    }
    
    NSString *responseData = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
    _myCourseList = [[[[[[jsonData objectForKey:@"ssr_get_courses_resp"] objectForKey:@"course_search_result"] objectForKey:@"subjects"] objectForKey: @"subject"] objectForKey:@"course_summaries"] objectForKey: @"course_summary"];
    
    [self.tableView reloadData];
}

//TODO: add activity indicator somewhere
- (void) getCourseList {
    [self showActivityIndicator];
    
    @try {
        [DatabaseCore getCourseList: _mySubject completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
            [self getCourseListCompletionHandler:response data:data error:error];
        }];
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self hideActivityIndicator];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myCourseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *subject = [[_myCourseList objectAtIndex: indexPath.item] objectForKey: @"subject"];
    NSString *catalog_nbr = [[_myCourseList objectAtIndex: indexPath.item] objectForKey: @"catalog_nbr"];
    NSString *course_title = [[_myCourseList objectAtIndex: indexPath.item] objectForKey: @"course_title_long"];
    
    cell.myLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", subject, catalog_nbr, course_title];
    return cell;
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass: [CourseTabViewController class]]) {
        CourseTabViewController* ctvc = [segue destinationViewController];
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        
        NSString *subject = [[_myCourseList objectAtIndex: selected.item] objectForKey: @"subject"];
        NSString *catalog_nbr = [[_myCourseList objectAtIndex: selected.item] objectForKey: @"catalog_nbr"];
        NSString *course_title = [[_myCourseList objectAtIndex: selected.item] objectForKey: @"course_title_long"];
        ctvc.myCourse = [NSString stringWithFormat:@"%@ %@ - %@", subject, catalog_nbr, course_title];
        NSLog(@"Course: %@", ctvc.myCourse); //DEBUG
    }
}


@end
