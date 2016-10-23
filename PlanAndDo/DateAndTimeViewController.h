//
//  DateAndTimeViewController.h
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"

typedef NS_ENUM(NSInteger, DateAndTimeState)
{
    DateAndTimeStateNormal,
    DateAndTimeStateRecall
};

@interface DateAndTimeViewController : BaseTableViewController

@property NSDate* completionTime;
@property NSDate* completionReminderTime;
@property UIViewController* parentController;

@end
