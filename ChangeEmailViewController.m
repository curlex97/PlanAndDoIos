//
//  ChangeEmailViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "KSApplicatipnColor.h"

#define TEXTFIELD_PADDING_LEFT 10


@interface ChangeEmailViewController ()

@end

@implementation ChangeEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    [self.tableView removeFromSuperview];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    UIView *oldEmailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.oldEmailTextField.leftView = oldEmailPaddingView;
    self.oldEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *reenterEmailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.reenterEmailTextField.leftView = reenterEmailPaddingView;
    self.reenterEmailTextField.leftViewMode = UITextFieldViewModeAlways;
}



@end
