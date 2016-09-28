//
//  TaskListViewController.h
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ApplicationManager.h"
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"

@interface TaskListViewController : BaseTableViewController
@property (nonatomic)NSMutableArray<KSShortTask *> * subTasks;
@property KSTaskCollection* task;
@property UIViewController* parentController;
@end
