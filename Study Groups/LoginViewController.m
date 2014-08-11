//
//  LoginViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 6/2/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"
#import "DatabaseCore.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    _myEmail.delegate = self;
    _myPassword.delegate = self;
    
    _myLoginButton.layer.borderWidth = .5f;
    _myLoginButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _myRegisterButton.layer.borderWidth = .5f;
    _myRegisterButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _myActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _myActivityIndicator.layer.backgroundColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
    _myActivityIndicator.layer.cornerRadius = 10.0f;
    _myActivityIndicator.frame = CGRectMake(0, 0, 55, 55);
    _myActivityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0));
    [self.view addSubview: _myActivityIndicator];
    
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

#pragma mark - Register Button

-(IBAction) registerClicked:(UIButton *) sender {
    [self performSegueWithIdentifier:@"register-segue" sender:self];
}

#pragma mark - Login Button 

-(void) alertStatus:(NSString *)msg :(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(bool) validateLoginInput: (NSString *) email password:(NSString *) password {
    if ([email isEqualToString:@""] || [password isEqualToString:@""]) {
        [self alertStatus:@"Please enter Duke email and password!" :@"Login Failed!"];
        return false;
        
    } else if (![_myEmail.text hasSuffix:@"@duke.edu"]) {
        [self alertStatus:@"Email must be a Duke address!" :@"Login Failed!"];
        return false;
    }
    return true;
}

-(void) validateLoginCompletionHandler: (NSURLResponse *)response data:(NSData *)data error:(NSError *) error {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"status code = %d", [httpResponse statusCode]);
    
    [self hideActivityIndicator];
    
    if ([httpResponse statusCode] < 200 || [httpResponse statusCode] >= 300) {
        NSLog(@"Error: %@ || Status Code: %d", error, [httpResponse statusCode]);
        [self alertStatus:@"Connection failed." : @"Login failed!"];
        return;
    }
    
    NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
    NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
    
    NSLog(@"success = %d", success);
    
    if (success != 1) {
        [self alertStatus:[jsonData objectForKey:@"error_message"] :@"Login Failed!"];
        return;
    }
    
    [self alertStatus: @"Logged in successfully." : @"Login success!"];
    [self performSegueWithIdentifier:@"login-segue" sender:self];
}

-(void) login {    
    if (![self validateLoginInput: _myEmail.text password: _myPassword.text]) {
        return;
    }
    
    [self showActivityIndicator];
    
    @try {
        [DatabaseCore validateLogin:_myEmail.text password: _myPassword.text completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
            [self validateLoginCompletionHandler:response data:data error:error];
        }];
        
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self hideActivityIndicator];
        [self alertStatus:@"Login failed." :@"Login failed!"];
    }
}

-(IBAction) loginClicked:(UIButton *) sender {
    [self login];
}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
