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

@interface AddTaskViewController : BaseTableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
-(instancetype)initWithCategory:(KSCategory *)category;
@property KSCategory* category;
@property NSDate* completionTime;
@property NSString* taskDesc;
@end
