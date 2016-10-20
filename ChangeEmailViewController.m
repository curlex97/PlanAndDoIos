//
//  ChangeEmailViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "KSApplicationColor.h"
#import "ApplicationManager.h"




@interface ChangeEmailViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)NSRegularExpression * regex;
@end

@implementation ChangeEmailViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.emailTextField.isFirstResponder)
    {
        [self.reenterEmailTextField becomeFirstResponder];
        if([self.regex matchesInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)].count>0)
        {
            self.emailTextField.rightViewMode=UITextFieldViewModeNever;
        }
    }
    else if(self.oldEmailTextField.isFirstResponder)
    {
        [self.emailTextField becomeFirstResponder];
        if([self.oldEmailTextField.text isEqualToString:[ApplicationManager userApplicationManager].authorisedUser.emailAdress])
        {
            self.oldEmailTextField.rightViewMode=UITextFieldViewModeNever;
        }
    }
    else
    {
        if(self.submitButton.isEnabled)
        {
            [self.alertView setHidden:YES];
            self.oldEmailTextField.rightViewMode=UITextFieldViewModeNever;
            self.emailTextField.rightViewMode=UITextFieldViewModeNever;
            self.reenterEmailTextField.rightViewMode=UITextFieldViewModeNever;
            [self submitDidTap:nil];
        }
        else
        {
            [self.reenterEmailTextField resignFirstResponder];
        }
        
        if([self.reenterEmailTextField.text isEqualToString:self.oldEmailTextField.text])
        {
            self.emailTextField.rightViewMode=UITextFieldViewModeNever;
            self.reenterEmailTextField.rightViewMode=UITextFieldViewModeNever;
        }
    }
    
    if(self.oldEmailTextField.text.length>0 && ![self.oldEmailTextField.text isEqualToString:[ApplicationManager userApplicationManager].authorisedUser.emailAdress])
    {
        [self.alertView setHidden:NO];
        self.alertMessage.text=@"Incorrect Email";
        self.oldEmailTextField.rightViewMode=UITextFieldViewModeAlways;
    }
    
    if(self.emailTextField.text.length>0 && [self.regex matchesInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)].count==0)
    {
        [self.alertView setHidden:NO];
        self.alertMessage.text=@"Invalid new Email";
        self.emailTextField.rightViewMode=UITextFieldViewModeAlways;
    }
    
    if(self.reenterEmailTextField.text.length>0 && ![self.reenterEmailTextField.text isEqualToString:self.emailTextField.text])
    {
        [self.alertView setHidden:NO];
        self.alertMessage.text=@"Emails not equal";
        self.reenterEmailTextField.rightViewMode=UITextFieldViewModeAlways;
        self.emailTextField.rightViewMode=UITextFieldViewModeAlways;
    }

    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer locationInView:self.oldEmailTextField].y>=CS_CHANGE_EMAIL_GESTURE_MIN && [gestureRecognizer locationInView:self.oldEmailTextField].y<CS_CHANGE_EMAIL_GESTURE_MAX)
    {
        
    }
    else
    {
        if(self.emailTextField.isFirstResponder)
        {
            [self.emailTextField resignFirstResponder];
        }
        else if(self.oldEmailTextField.isFirstResponder)
        {
            [self.oldEmailTextField resignFirstResponder];
        }
        else
        {
            [self.reenterEmailTextField resignFirstResponder];
        }
    }
    return YES;
}

-(void)validateEnteredText
{
    if(self.emailTextField.text.length>1 && self.oldEmailTextField.text.length>1 && self.reenterEmailTextField.text.length>1 &&
       [self.regex matchesInString:self.oldEmailTextField.text options:0 range:NSMakeRange(0, self.oldEmailTextField.text.length)].count>0 &&
       [self.regex matchesInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)].count>0 &&
       [self.regex matchesInString:self.reenterEmailTextField.text options:0 range:NSMakeRange(0, self.reenterEmailTextField.text.length)].count>0)
    {
        self.submitButton.enabled=YES;
        [self.submitButton setHighlighted:NO];
    }
    else
    {
        [self.submitButton setHighlighted:YES];
        self.submitButton.enabled=NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=NM_CHANGE_EMAIL;
    
    UIImageView * oldEmailImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertIcon"]];
    UIView * oldEmailAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 20.0)];
    [oldEmailAlertView addSubview:oldEmailImageView];
    UIView *oldEmailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.oldEmailTextField.leftView = oldEmailPaddingView;
    self.oldEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oldEmailTextField.rightView = oldEmailAlertView;
    self.oldEmailTextField.rightViewMode = UITextFieldViewModeNever;
    self.oldEmailTextField.delegate=self;
    [self.oldEmailTextField addTarget:self action:@selector(validateEnteredText) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView * emailImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertIcon"]];
    UIView * emailAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 20.0)];
    [emailAlertView addSubview:emailImageView];
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.rightView = emailAlertView;
    self.emailTextField.rightViewMode = UITextFieldViewModeNever;
    self.emailTextField.delegate=self;
    [self.emailTextField addTarget:self action:@selector(validateEnteredText) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView * reenterEmailImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertIcon"]];
    UIView * reenterEmailAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 20.0)];
    [reenterEmailAlertView addSubview:reenterEmailImageView];
    UIView *reenterEmailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CS_TEXTFIELD_PADDING_LEFT, 0)];
    self.reenterEmailTextField.leftView = reenterEmailPaddingView;
    self.reenterEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.reenterEmailTextField.rightView = reenterEmailAlertView;
    self.reenterEmailTextField.rightViewMode = UITextFieldViewModeNever;
    self.reenterEmailTextField.delegate=self;
    [self.reenterEmailTextField addTarget:self action:@selector(validateEnteredText) forControlEvents:UIControlEventEditingChanged];
    
    NSError * Error;
    self.regex=[[NSRegularExpression alloc] initWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                                                    options:NSRegularExpressionDotMatchesLineSeparators
                                                      error:&Error];
    if(Error)
    {
        NSLog(@"%@",Error.localizedDescription);
    }
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.view addGestureRecognizer:self.tap];
    
    [self.alertView setHidden:YES];
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
- (IBAction)submitDidTap:(UIButton *)sender
{
    KSAuthorisedUser* user = [[ApplicationManager userApplicationManager] authorisedUser];
    if([self.oldEmailTextField.text isEqualToString:user.emailAdress] && [self.emailTextField.text isEqualToString:self.reenterEmailTextField.text])
    {
        user.emailAdress = self.emailTextField.text;
        [[ApplicationManager userApplicationManager] updateUser:user completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_EMAIL_CHANGED object:user];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
