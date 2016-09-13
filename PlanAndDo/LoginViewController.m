//
//  LoginViewController.m
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "KSApplicatipnColor.h"

#define TEXTFIELD_PADDING_LEFT 10


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    [self.tableView removeFromSuperview];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    UIView *loginPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.loginTextField.leftView = loginPaddingView;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
