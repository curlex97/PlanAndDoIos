//
//  TabletasksViewController.h
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "KSCategory.h"
#import "KSTask.h"
#import "KSTaskCollection.h"
#import "TasksCoreDataManager.h"

typedef NS_ENUM(NSInteger, KSBoxType)
{
    KSBoxTypeToday,
    KSBoxTypeTomorrow,
    KSBoxTypeWeek,
    KSBoxTypeBacklog,
    KSBoxTypeArchive
};

@interface TabletasksViewController : BaseTableViewController
@property KSBoxType boxType;
@property NSMutableArray<BaseTask*>* tasks;
@property KSCategory* category;
@end
