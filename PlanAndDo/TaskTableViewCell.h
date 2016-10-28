//
//  TaskTableViewCell.h
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface TaskTableViewCell : MGSwipeTableCell
@property (strong, nonatomic) IBOutlet UILabel *taskHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskPriorityLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ringImageView;

@end
