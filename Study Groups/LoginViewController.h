//
//  LoginViewController.h
//  Study Groups
//
//  Created by Nicholas Gordon on 6/2/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myLogo;
@property (weak, nonatomic) IBOutlet UITextField *myEmail;
@property (weak, nonatomic) IBOutlet UITextField *myPassword;
@property (weak, nonatomic) IBOutlet UIButton *myLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *myRegisterButton;
@property (strong, nonatomic) UIActivityIndicatorView *myActivityIndicator;

@end
