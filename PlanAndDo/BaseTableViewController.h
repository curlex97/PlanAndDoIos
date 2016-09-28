//
//  BaseTableViewController.h
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController
@property (nonatomic)UITableView * tableView;
@property (nonatomic)UIRefreshControl * refresh;
@property (nonatomic)UIView * emptyTableHeader;

@property NSLayoutConstraint *trailing;
@property NSLayoutConstraint *leading;
@property NSLayoutConstraint *bottom;
@property NSLayoutConstraint *top;
@end
