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
    _myActivityIndicator.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor];
    _myActivityIndicator.frame = CGRectMake(0, 0, 50, 50);
    _myActivityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0) - 40);
    [self.view addSubview: _myActivityIndicator];
    
    [self showActivityIndicator];
    [self performSelector: @selector(getSubjectList) withObject:nil afterDelay:0.0001]; //delay required to allow UI to repaint with activity indicator.

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

//TODO: add activity indicator somewhere
- (void) getSubjectList {
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
            _mySubjectList = subjectData;
        }
        else {
            if (error) {NSLog(@"Error: %@", error);}
            NSLog(@"Connection failed!");
            _mySubjectList = nil;
        }
        [self.tableView reloadData];
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e); //DEBUG
    }
    @finally {
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