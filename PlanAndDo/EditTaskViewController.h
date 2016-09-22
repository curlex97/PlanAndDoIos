//
//  EditTaskViewController.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 20.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "KSTask.h"
#import "KSTaskCollection.h"

@interface EditTaskViewController : BaseTableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property BaseTask* task;
@end
