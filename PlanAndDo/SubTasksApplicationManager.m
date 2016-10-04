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
    [[[SyncApplicationManager alloc] init]syncSubTasksWithCompletion:^(bool status) {
        [[[SubTasksApiManager alloc] init] addSubTaskAsync:subTask toTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        }];
    }];
    
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] updateSubTask:subTask forTask:task];
    [[[SyncApplicationManager alloc] init] syncSubTasksWithCompletion:^(bool status) {
        [[[SubTasksApiManager alloc] init] updateSubTaskAsync:subTask inTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        }];
    }];
    
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    [[[SubTasksCoreDataManager alloc] init] deleteSubTask:subTask forTask:task];
    [[[SyncApplicationManager alloc] init] syncSubTasksWithCompletion:^(bool status) {
        [[[SubTasksApiManager alloc] init] deleteSubTaskAsync:subTask fromTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        }];
    }];
}

-(void) cleanTable
{
    return [[[SubTasksCoreDataManager alloc] init] cleanTable];
}

@end
