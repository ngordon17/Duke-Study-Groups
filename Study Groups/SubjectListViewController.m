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
#import "CourseListViewcontroller.h"
#import "DatabaseCore.h";

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
    
    _myActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _myActivityIndicator.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
    _myActivityIndicator.layer.cornerRadius = 10.0f;
    _myActivityIndicator.frame = CGRectMake(0, 0, 55, 55);
    _myActivityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0));
    [self.view addSubview: _myActivityIndicator];
    
    [self getSubjectList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) getSubjectListCompletionHandler: (NSURLResponse *)response data:(NSData *)data error:(NSError *) error {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    [self hideActivityIndicator];
    
    if ([httpResponse statusCode] < 200 || [httpResponse statusCode] >= 300) {
        NSLog(@"Error: %@ || Status Code: %d", error, [httpResponse statusCode]);
        return;
    }
    
    NSString *responseData = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
    _mySubjectList = [[[[[jsonData objectForKey:@"scc_lov_resp"] objectForKey:@"lovs"] objectForKey:@"lov"] objectForKey: @"values"] objectForKey:@"value"];

    [self.tableView reloadData];
}

- (void) getSubjectList {
    [self showActivityIndicator];
    
    @try {
        [DatabaseCore getSubjectList: ^(NSURLResponse *response, NSData *data, NSError *error) {
            [self getSubjectListCompletionHandler:response data:data error:error];
        }];
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e); //DEBUG
        [self hideActivityIndicator];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass: [CourseListViewController class]]) {
        CourseListViewController* clvc = [segue destinationViewController];
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        NSString *code = [[_mySubjectList objectAtIndex: selected.item] objectForKey:@"code"];
        NSString *desc = [[_mySubjectList objectAtIndex: selected.item] objectForKey:@"desc"];
        clvc.mySubject = [NSString stringWithFormat:@"%@ - %@", code, desc];
        NSLog(@"Subject: %@", clvc.mySubject); //DEBUG
    }
}

@end