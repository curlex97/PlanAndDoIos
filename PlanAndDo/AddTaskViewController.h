//
//  AddTaskViewController.h
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "ApplicationManager.h"
#import "ApplicationDefines.h"

@interface AddTaskViewController : BaseTableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
-(instancetype)initWithCategory:(KSCategory *)category andDate:(NSDate *)date;
@property KSCategory* category;
@property NSDate* completionTime;
@property NSString* taskDesc;
@property NSMutableArray* subTasks;
@end
