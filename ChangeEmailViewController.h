//
//  ChangeEmailViewController.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeEmailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *oldEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *reenterEmailTextField;
@end
