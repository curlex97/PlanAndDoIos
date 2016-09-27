//
//  NewPasswordViewController.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseAuthViewController.h"

@interface NewPasswordViewController : BaseAuthViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *backTextFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@end
