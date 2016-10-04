//
//  SubTasksApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksApplicationManager.h"
#import "ApplicationManager.h"
#import "SyncApplicationManager.h"

@implementation SubTasksApplicationManager

-(NSArray<KSShortTask *> *)allSubTasksForTask:(KSTaskCollection *)task
{
    return [[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task];
}

-(void)addSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] addSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] addSubTaskAsync:subTask toTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){}];
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] updateSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] updateSubTaskAsync:subTask inTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){}];
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] deleteSubTask:subTask forTask:task];
    [[[SubTasksApiManager alloc] init] deleteSubTaskAsync:subTask fromTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){}];
}

-(void) cleanTable
{
    return [[[SubTasksCoreDataManager alloc] init] cleanTable];
}

@end
