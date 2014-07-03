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
    _myCourseList = [self getCourseList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Retrieve data

//TODO: add activity indicator somewhere
- (NSArray *) getCourseList {
    @try {
        
    
        NSString *escapedSubject = [_mySubject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *address = [NSString stringWithFormat:@"https://streamer.oit.duke.edu/curriculum/courses/subject/%@?access_token=a90cec76bce0a30d4a53aca6ca780448", escapedSubject];
        NSURL *url = [NSURL URLWithString:address];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL: url];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog(@"Response code: %d", [response statusCode]); //DEBUG
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            NSString *responseData = [[NSString alloc] initWithData: urlData encoding:NSUTF8StringEncoding];
            //NSLog(@"Response ==> %@", responseData); //DEBUG
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            //NSLog(@"%@", jsonData); //DEBUG
            NSArray *courseData = [[[[[[jsonData objectForKey:@"ssr_get_courses_resp"] objectForKey:@"course_search_result"] objectForKey:@"subjects"] objectForKey: @"subject"] objectForKey:@"course_summaries"] objectForKey: @"course_summary"];
            NSLog(@"%@", courseData); //DEBUG
            return courseData;
        }
        else {
            if (error) {NSLog(@"Error: %@", error);}
            NSLog(@"Connection failed! Please check your internet connection and try again.");
            return nil;
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e); //DEBUG
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
