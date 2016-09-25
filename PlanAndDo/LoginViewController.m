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


@interface LoginViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@end

@implementation LoginViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%f",[gestureRecognizer locationInView:self.loginTextField].y);
        [self.passwordTextField resignFirstResponder];
        [self.loginTextField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *loginPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.loginTextField.leftView = loginPaddingView;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification *)not
{
    [self.view removeGestureRecognizer:self.tap];
    
    [UIView animateWithDuration:1 animations:^
     {
         self.backTextFieldView.frame=CGRectMake(self.backTextFieldView.frame.origin.x,
                                                 self.view.bounds.size.height/2-self.backTextFieldView.frame.size.height/2,
                                                 self.backTextFieldView.frame.size.width,
                                                 self.backTextFieldView.frame.size.height);
     } completion:^(BOOL finished)
     {
     }];
}

-(void)keyboardWillShown:(NSNotification *)not
{
    [self.view addGestureRecognizer:self.tap];
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [UIView animateWithDuration:1 animations:^
     {
         self.backTextFieldView.frame=CGRectMake(self.backTextFieldView.frame.origin.x,
                                                 [aValue CGRectValue].origin.y-self.backTextFieldView.frame.size.height-70,
                                                 self.backTextFieldView.frame.size.width,
                                                 self.backTextFieldView.frame.size.height);
     } completion:^(BOOL finished)
     {
     }];
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
    
//    [[ApplicationManager userApplicationManager] loginWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text completion:^(bool fl) {
//       // if(fl)
//        {
            AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:[[UINavigationController alloc] initWithRootViewController:[[TabletasksViewController alloc] init]] andBackVC:[[KSMenuViewController alloc] init]];
            
            if(tableTaskViewController)
            {
                tableTaskViewController.title=@"Today";
                [self presentViewController:tableTaskViewController animated:YES completion:nil];
            }
//        }
//    }];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
