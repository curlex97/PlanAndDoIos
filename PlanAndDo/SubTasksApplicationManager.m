//
//  SubTasksApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksApplicationManager.h"

@implementation SubTasksApplicationManager

-(NSArray<KSShortTask *> *)allSubTasksForTask:(KSTaskCollection *)task
{
    return [[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task];
}

-(void)addSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] addSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] addSubTaskAsync:subTask toTask:task forUser:nil];
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] updateSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] updateSubTaskAsync:subTask inTask:task forUser:nil];
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] deleteSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] deleteSubTaskAsync:subTask fromTask:task forUser:nil];
}

@end
