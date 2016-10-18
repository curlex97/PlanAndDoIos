//
//  LoginViewController.m
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "KSApplicationColor.h"
#import "CreateAccountViewController.h"
#import "NewPasswordViewController.h"
#import "TabletasksViewController.h"
#import "AMSideBarViewController.h"
#import "KSMenuViewController.h"
#import "ApplicationManager.h"


@interface LoginViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)NSRegularExpression * emailRegex;
@property (nonatomic)NSRegularExpression * passRegex;
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([ApplicationManager userApplicationManager].authorisedUser.emailAdress.length==0 && !self.isViewPresented)
    {
        LoginViewController * login=[self.baseStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        login.isViewPresented=YES;
        [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:NO completion:^
         {
             [self.navigationController popViewControllerAnimated:NO];
         }];
        self.navigationItem.hidesBackButton=YES;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!self.alertView.hidden)
    {
        [self.alertView setHidden:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.passwordTextField.isFirstResponder)
    {
        [self.passwordTextField resignFirstResponder];
        if(self.signInButton.isEnabled)
        {
            [self signInTapped:nil];
        }
    }
    else
    {
        [self.passwordTextField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer locationInView:self.loginTextField].y>=CS_LOGIN_GESTURE_MIN && [gestureRecognizer locationInView:self.loginTextField].y<CS_LOGIN_GESTURE_MAX)
    {
        NSLog(@"%f",[gestureRecognizer locationInView:self.loginTextField].y);
    }
    else
    {
        if(self.passwordTextField.isFirstResponder)
        {
            [self.passwordTextField resignFirstResponder];
        }
        else
        {
            [self.loginTextField resignFirstResponder];
        }
    }
    return YES;
}

-(void)showMainWindow:(NSNotification*)not
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self dismissViewControllerAnimated:YES completion:nil];
                   });
}

-(void)validateEnteredText:(UITextField *)sender
{
    BOOL isValid=NO;
    if(self.loginTextField==sender && [self.emailRegex matchesInString:self.loginTextField.text options:0 range:NSMakeRange(0, self.loginTextField.text.length)].count>0)
    {
        isValid=YES;
    }
    else
    {
        isValid=NO;
        self.loginTextField.clearButtonMode=UITextFieldViewModeAlways;
    }
    
    if(self.passwordTextField==sender && [self.passRegex matchesInString:self.passwordTextField.text options:0 range:NSMakeRange(0, self.passwordTextField.text.length)].count>0)
    {
        isValid=YES;

    }
    else
    {
        isValid=NO;
    }
    
    if(isValid)
    {
        self.signInButton.enabled=YES;
        [self.signInButton setHighlighted:NO];
    }
    else
    {
        [self.signInButton setHighlighted:YES];
        self.signInButton.enabled=NO;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *loginPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.loginTextField.leftView = loginPaddingView;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginTextField.delegate=self;
    [self.loginTextField addTarget:self action:@selector(validateEnteredText:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate=self;
    [self.passwordTextField addTarget:self action:@selector(validateEnteredText:) forControlEvents:UIControlEventEditingChanged];
    
    [self.alertView setHidden:YES];
    
    NSError * emailError;
    self.emailRegex=[[NSRegularExpression alloc] initWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                                                         options:NSRegularExpressionDotMatchesLineSeparators
                                                           error:&emailError];
    if(emailError)
    {
        NSLog(@"%@",emailError.localizedDescription);
    }
    
    NSError * passError;
    self.passRegex=[[NSRegularExpression alloc] initWithPattern:@"[A-Z0-9a-z]{6,32}"
                                                        options:NSRegularExpressionDotMatchesLineSeparators
                                                          error:&passError];
    if(passError)
    {
        NSLog(@"%@",passError.localizedDescription);
    }
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.view addGestureRecognizer:self.tap];
    
    [self.signInButton setHighlighted:YES];
    self.signInButton.enabled=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification *)not
{
    self.tap.enabled=NO;
    self.centerConstraint.constant=-29.0;
    [UIView animateWithDuration:5 animations:^
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

- (IBAction)createNewAccountTapped:(id)sender
{
    CreateAccountViewController* cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
    
    if(cavc)
    {
        cavc.navigationItem.title = NM_CREATE_ACCOUNT;
        [self.navigationController pushViewController:cavc animated:YES];
    }
}
- (IBAction)newPasswordTapped:(id)sender {
    NewPasswordViewController* cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewPasswordViewController"];
    
    if(cavc)
    {
        cavc.navigationItem.title = NM_NEW_PASSWORD;
        [self.navigationController pushViewController:cavc animated:YES];
    }
}

- (IBAction)signInTapped:(id)sender
{
    [self.navigationController.view addSubview:self.loadContentView];
    [[ApplicationManager userApplicationManager] loginWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text completion:^(bool status)
     {
         if(status)
         {
             [[ApplicationManager syncApplicationManager] syncWithCompletion:^(BOOL status)
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                     [self.loadContentView removeFromSuperview];
                     [self showMainWindow:nil];
                 });
             }];
         }
         else
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                            {
                                [self.loadContentView removeFromSuperview];
                                self.loginTextField.text=@"";
                                self.passwordTextField.text=@"";
                                [self.signInButton setHighlighted:YES];
                                self.signInButton.enabled=NO;
                                self.alertMessage.text=@"Invalid email or password";
                                [self.alertView setHidden:NO];
                            });
         }
     }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
