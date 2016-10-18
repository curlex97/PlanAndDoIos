//
//  LoginViewController.h
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseAuthViewController.h"

@interface LoginViewController : BaseAuthViewController
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *backTextFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UILabel *alertMessage;

@property (nonatomic)BOOL isViewPresented;
@end
