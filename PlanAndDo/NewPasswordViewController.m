//
//  NewPasswordViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "KSApplicatipnColor.h"

#define TEXTFIELD_PADDING_LEFT 10



@implementation NewPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    [self.tableView removeFromSuperview];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
