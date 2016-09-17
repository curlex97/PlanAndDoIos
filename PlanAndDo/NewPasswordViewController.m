//
//  NewPasswordViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "KSApplicatipnColor.h"
#import "ChangeEmailViewController.h"
#import "SettingsViewController.h"
#import "CoreDataManager.h"


#define TEXTFIELD_PADDING_LEFT 10



@implementation NewPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer * gradient=[KSApplicatipnColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    

    
    
}
- (IBAction)sendNewPasswordTapped:(id)sender {
    
//    ChangeEmailViewController* cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeEmailViewController"];
//    
//    if(cavc)
//    {
//        cavc.navigationItem.title = @"Change email";
//        [self.navigationController pushViewController:cavc animated:YES];
//    }
    
    [CoreDataManager managedObjectContext];
    
    SettingsViewController * tableTaskViewController=[[SettingsViewController alloc] init];
    
    if(tableTaskViewController)
    {
        tableTaskViewController.title=@"Settings";
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tableTaskViewController] animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
