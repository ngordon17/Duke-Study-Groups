//
//  StudyGroupViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 7/5/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "StudyGroupViewController.h"

@interface StudyGroupViewController ()

@end

@implementation StudyGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self performSelector: @selector(getGroupData) withObject:nil afterDelay:0.0001]; //delay required to allow UI to repaint with activity indicator.
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

- (void) getGroupData {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
