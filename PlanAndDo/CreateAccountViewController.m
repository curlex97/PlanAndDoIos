//
//  CreateAccountViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "KSApplicationColor.h"
#import "ApplicationManager.h"
#import "TabletasksViewController.h"
#import "AMSideBarViewController.h"
#import "KSMenuViewController.h"


@interface CreateAccountViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@end

@implementation CreateAccountViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.passwordTextField.isFirstResponder)
    {
        [self.reenterPasswordTextField becomeFirstResponder];
    }
    else if(self.emailTextField.isFirstResponder)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(self.usernameTextField.isFirstResponder)
    {
        [self.emailTextField becomeFirstResponder];
    }
    else
    {
        [self.reenterPasswordTextField resignFirstResponder];
        if(self.submitButton.isEnabled)
        {
            [self submitTapped:nil];
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer locationInView:self.usernameTextField].y>=0 && [gestureRecognizer locationInView:self.usernameTextField].y<44*4)
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.usernameTextField.text.length>1 && self.passwordTextField.text.length>1 && self.emailTextField.text.length>1 && self.reenterPasswordTextField.text.length>1)
    {
        self.submitButton.enabled=YES;
        [self.submitButton setHighlighted:NO];
    }
    else
    {
        [self.submitButton setHighlighted:YES];
        self.submitButton.enabled=NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer * gradient=[KSApplicationColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.delegate=self;
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.usernameTextField.leftView = usernamePaddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextField.delegate=self;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate=self;
    
    UIView *reenterPasswordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.reenterPasswordTextField.leftView = reenterPasswordPaddingView;
    self.reenterPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.reenterPasswordTextField.delegate=self;
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.view addGestureRecognizer:self.tap];
    
    [self.submitButton setHighlighted:YES];
    self.submitButton.enabled=NO;
    
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

- (IBAction)submitTapped:(id)sender
{
    if([self.passwordTextField.text isEqualToString:self.reenterPasswordTextField.text])
    {
        [[ApplicationManager userApplicationManager] registerAsyncWithEmail:self.emailTextField.text andUserName:self.usernameTextField.text andPassword:self.passwordTextField.text completion:^(bool fl)
        {
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    }];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
