//
//  CourseListViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 6/3/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "SubjectListViewController.h"
#import "SBJson.h"
#import "SubjectListViewCell.h"

@interface SubjectListViewController ()

@end

@implementation SubjectListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mySubjectList = [self getSubjectList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Retrieve data

//TODO: add activity indicator somewhere
- (NSArray *) getSubjectList {
    @try {
        NSURL *url = [NSURL URLWithString:@"https://streamer.oit.duke.edu/curriculum/list_of_values/fieldname/SUBJECT?access_token=a90cec76bce0a30d4a53aca6ca780448"];
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
            NSArray *subjectData = [[[[[jsonData objectForKey:@"scc_lov_resp"] objectForKey:@"lovs"] objectForKey:@"lov"] objectForKey: @"values"] objectForKey:@"value"];
            //NSLog(@"%@", subjectData); //DEBUG
            return subjectData;
        }
        else {
            if (error) {NSLog(@"Error: %@", error);}
            NSLog(@"Connection failed!");
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
    return [_mySubjectList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.myLabel.text = [[_mySubjectList objectAtIndex:indexPath.item] objectForKey:@"desc"];
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
