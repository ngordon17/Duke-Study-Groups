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
        NSString *address = [[@"https://streamer.oit.duke.edu/curriculum/list_of_values/fieldname/" stringByAppendingString:_mySubject] stringByAppendingString:@"?access_token=a90cec76bce0a30d4a53aca6ca780448"];
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
            NSArray *subjectData = [[[[[jsonData objectForKey:@"scc_lov_resp"] objectForKey:@"lovs"] objectForKey:@"lov"] objectForKey: @"values"] objectForKey:@"value"];
            //NSLog(@"%@", subjectData); //DEBUG
            return subjectData;
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
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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