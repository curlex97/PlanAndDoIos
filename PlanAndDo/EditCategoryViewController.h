//
//  EditCategoryViewController.h
//  PlanAndDo
//
//  Created by Амин on 16.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "KSCategory.h"
#import "EditCategoryTableViewCell.h"
#import "ApplicationManager.h"
#import "KSSplitViewController.h"
#import "TabletasksViewController.h"

@interface EditCategoryViewController : BaseTableViewController
@property (nonatomic)NSMutableArray<KSCategory *> * categories;
@end
