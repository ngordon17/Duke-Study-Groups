//
//  LoginViewController.m
//  Study Groups
//
//  Created by Nicholas Gordon on 6/2/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"

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
    [self setNeedsStatusBarAppearanceUpdate];
    _myEmail.delegate = self;
    _myPassword.delegate = self;
    _myLoginButton.layer.borderWidth = .5f;
    _myLoginButton.layer.borderColor = [[UIColor whiteColor]CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login Button 

-(void) alertStatus:(NSString *)msg :(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

//SOURCE:http://dipinkrishna.com/blog/2012/03/iphoneios-programming-login-screen-post-data-url-parses-json-response/5/
-(IBAction) loginClicked:(UIButton *) sender {
    NSLog(@"Attempting Login... Email: %@ || Password: %@", _myEmail.text, _myPassword.text); //DEBUG
    //TODO: verify login and retrieve user id
    @try {
        if ([_myEmail.text isEqualToString:@""] || [_myPassword.text isEqualToString:@""]) {
            [self alertStatus:@"Please enter email and password!" :@"Login Failed!"];
        }
        else {
            NSString *post = [[NSString alloc] initWithFormat:@"username=%@&password=%@", _myEmail.text, _myPassword.text];
            NSLog(@"Post Data: %@", post); //DEBUG
            NSURL *url = [NSURL URLWithString:@"http://dipinkrishna.com/jsonlogin.php"]; //TODO: make actual website thing
            //NSURL *url = [NSURL URLWithString:@"http://dukestudygroups.com/login.php"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL: url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSLog(@"Response code: %d", [response statusCode]); //DEBUG
            if ([response statusCode] >= 200 && [response statusCode] < 300) {
                NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData); //DEBUG
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                NSLog(@"%@", jsonData);
                NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
                NSLog(@"%d", success); //DEBUG
                if (success == 1) {
                    NSLog(@"Login successful!"); //DEBUG
                    [self alertStatus:@"Logged in successfully." : @"Login sucess!"];
                    //REDIRECT!
                }
                else {
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                    [self alertStatus:error_msg:@"Login Failed!"];
                }
            }
            else {
                if (error) {NSLog(@"Error: %@", error);}
                [self alertStatus:@"Connection failed." : @"Login failed!"];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e); //DEBUG
        [self alertStatus:@"Login failed." :@"Login failed!"];
    }
}


#pragma mark - Status Bar Options
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
