//
//  DateAndTimeViewController.h
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseViewController.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"

@interface DateAndTimeViewController : BaseViewController

@property NSDate* completionTime;
@property UIViewController* parentController;

@end
