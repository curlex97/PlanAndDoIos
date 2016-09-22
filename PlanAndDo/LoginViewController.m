//
//  LoginViewController.m
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "KSApplicatipnColor.h"
#import "CreateAccountViewController.h"
#import "NewPasswordViewController.h"
#import "TabletasksViewController.h"
#import "AMSideBarViewController.h"
#import "KSMenuViewController.h"
#import "ApplicationManager.h"

#define TEXTFIELD_PADDING_LEFT 10


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)createNewAccountTapped:(id)sender {
    
    CreateAccountViewController* cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
    
    if(cavc)
    {
        cavc.navigationItem.title = @"Create account";
        [self.navigationController pushViewController:cavc animated:YES];
    }
    
}
- (IBAction)newPasswordTapped:(id)sender {
    NewPasswordViewController* cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewPasswordViewController"];
    
    if(cavc)
    {
        cavc.navigationItem.title = @"New password";
        [self.navigationController pushViewController:cavc animated:YES];
    }
}

- (IBAction)signInTapped:(id)sender
{
    
    [[ApplicationManager userApplicationManager] loginWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text completion:^(bool fl) {
       // if(fl)
        {
            AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:[[UINavigationController alloc] initWithRootViewController:[[TabletasksViewController alloc] init]] andBackVC:[[KSMenuViewController alloc] init]];
            
            if(tableTaskViewController)
            {
                tableTaskViewController.title=@"Today";
                [self presentViewController:tableTaskViewController animated:YES completion:nil];
            }
        }
    }];
    
    
}

@end
