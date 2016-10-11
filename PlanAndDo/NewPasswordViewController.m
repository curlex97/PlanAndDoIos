//
//  NewPasswordViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "KSApplicationColor.h"
#import "ChangeEmailViewController.h"
#import "SettingsViewController.h"
#import "TasksCoreDataManager.h"
#import "SubTasksCoreDataManager.h"
#import "CategoryCoreDataManager.h"
#import "SettingsCoreDataManager.h"
#import "UserCoreDataManager.h"
#import "ApplicationManager.h"

@interface NewPasswordViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)NSRegularExpression * regex;
@end

@implementation NewPasswordViewController


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.sendButton.isEnabled)
    {
        [self sendNewPasswordTapped:nil];
    }
    else
    {
        [self.emailTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.emailTextField resignFirstResponder];
    return YES;
}

-(void)validateEnteredText
{
    if(self.emailTextField.text.length>1 &&
       [self.regex matchesInString:self.emailTextField.text options:0 range:NSMakeRange(0, self.emailTextField.text.length)].count>0)
    {
        self.sendButton.enabled=YES;
        [self.sendButton setHighlighted:NO];
    }
    else
    {
        [self.sendButton setHighlighted:YES];
        self.sendButton.enabled=NO;
    }
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
    [self.emailTextField addTarget:self action:@selector(validateEnteredText) forControlEvents:UIControlEventEditingChanged];
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.view addGestureRecognizer:self.tap];
    
    NSError * Error;
    self.regex=[[NSRegularExpression alloc] initWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                                                    options:NSRegularExpressionDotMatchesLineSeparators
                                                      error:&Error];
    if(Error)
    {
        NSLog(@"%@",Error.localizedDescription);
    }
    
    [self.sendButton setHighlighted:YES];
    self.sendButton.enabled=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)keyboardWillHide:(NSNotification *)not
{
    self.tap.enabled=NO;
    
//    [UIView animateWithDuration:1 animations:^
//     {
//         self.backTextFieldView.frame=CGRectMake(self.backTextFieldView.frame.origin.x,
//                                                 self.view.bounds.size.height/2-self.backTextFieldView.frame.size.height/2,
//                                                 self.backTextFieldView.frame.size.width,
//                                                 self.backTextFieldView.frame.size.height);
//     } completion:^(BOOL finished)
//     {
//     }];
}

-(void)keyboardWillShown:(NSNotification *)not
{
    self.tap.enabled=YES;
    
//    NSDictionary * info=[not userInfo];
//    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    [UIView animateWithDuration:1 animations:^
//     {
//         self.backTextFieldView.frame=CGRectMake(self.backTextFieldView.frame.origin.x,
//                                                 [aValue CGRectValue].origin.y-self.backTextFieldView.frame.size.height-70,
//                                                 self.backTextFieldView.frame.size.width,
//                                                 self.backTextFieldView.frame.size.height);
//     } completion:^(BOOL finished)
//     {
//     }];
}

- (IBAction)sendNewPasswordTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
