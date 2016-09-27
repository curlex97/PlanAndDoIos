//
//  CreateAccountViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "KSApplicatipnColor.h"
#import "ApplicationManager.h"
#import "TabletasksViewController.h"
#import "AMSideBarViewController.h"
#import "KSMenuViewController.h"

#define TEXTFIELD_PADDING_LEFT 10


@interface CreateAccountViewController () <UIGestureRecognizerDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@end

@implementation CreateAccountViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer locationInView:self.emailTextField].y>=0 && [gestureRecognizer locationInView:self.emailTextField].y<44*4)
    {

    }
    else
    {
        if(self.passwordTextField.isFirstResponder)
        {
            [self.passwordTextField resignFirstResponder];
        }
        else if(self.emailTextField.isFirstResponder)
        {
            [self.emailTextField resignFirstResponder];
        }
        else if(self.usernameTextField.isFirstResponder)
        {
            [self.usernameTextField resignFirstResponder];
        }
        else
        {
            [self.reenterPasswordTextField resignFirstResponder];
        }
    }

    return YES;
}

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
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.usernameTextField.leftView = usernamePaddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *reenterPasswordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TEXTFIELD_PADDING_LEFT, 0)];
    self.reenterPasswordTextField.leftView = reenterPasswordPaddingView;
    self.reenterPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.view addGestureRecognizer:self.tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification *)not
{
    self.tap.enabled=NO;
    self.centerConstraint.constant=0.0;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)keyboardWillShown:(NSNotification *)not
{
    self.tap.enabled=YES;
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.centerConstraint.constant-=self.backTextFieldView.frame.origin.y+self.backTextFieldView.frame.size.height-(self.view.bounds.size.height-[aValue CGRectValue].size.height);
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)submitTapped:(id)sender {
    
//    [[ApplicationManager userApplicationManager] registerAsyncWithEmail:@"qaqz12436@bb.com" andUserName:@"qaqz12643" andPassword:@"qaqz12643" completion:^(bool fl) {
//        AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:[[UINavigationController alloc] initWithRootViewController:[[TabletasksViewController alloc] init]] andBackVC:[[KSMenuViewController alloc] init]];
//        
//        if(tableTaskViewController && fl)
//        {
//            tableTaskViewController.title=@"Today";
//            [self presentViewController:tableTaskViewController animated:YES completion:nil];
//        }
//    }];

    
    if([self.passwordTextField.text isEqualToString:self.reenterPasswordTextField.text])
    [[ApplicationManager userApplicationManager] registerAsyncWithEmail:self.emailTextField.text andUserName:self.usernameTextField.text andPassword:self.passwordTextField.text completion:^(bool fl) {
        
        AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:[[UINavigationController alloc] initWithRootViewController:[[TabletasksViewController alloc] init]] andBackVC:[[KSMenuViewController alloc] init]];
        
        if(tableTaskViewController && fl)
        {
            tableTaskViewController.title=@"Today";
            dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:tableTaskViewController animated:YES completion:nil];
            });
        }
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
