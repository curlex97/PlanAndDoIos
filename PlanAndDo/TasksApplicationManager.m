//
//  TasksApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksApplicationManager.h"
#import "ApplicationManager.h"
#import "SyncApplicationManager.h"

@implementation TasksApplicationManager

-(NSArray<BaseTask *> *)allTasks
{
    return [[[TasksCoreDataManager alloc] init] allTasks];
}

-(NSArray<BaseTask *> *)allTasksForToday
{
    return [[[TasksCoreDataManager alloc] init] allTasksForToday];
}

-(NSArray<BaseTask *> *)allTasksForTomorrow
{
    return [[[TasksCoreDataManager alloc] init] allTasksForTomorrow];
}

-(NSArray<BaseTask *> *)allTasksForWeek
{
    return [[[TasksCoreDataManager alloc] init] allTasksForWeek];
}

-(NSArray<BaseTask *> *)allTasksForArchive
{
    return [[[TasksCoreDataManager alloc] init] allTasksForArchive];
}

-(NSArray<BaseTask *> *)allTasksForBacklog
{
    return [[[TasksCoreDataManager alloc] init] allTasksForBacklog];
}

-(NSArray<BaseTask *> *)allTasksForCategory:(KSCategory *)category
{
    return [[[TasksCoreDataManager alloc] init] allTasksForCategory:category];
}

-(BaseTask *)taskWithId:(int)Id
{
    return [[[TasksCoreDataManager alloc] init] taskWithId:Id];
}

-(void)addTask:(BaseTask *)task
{
    
    [[[TasksCoreDataManager alloc] init] addTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
        [[[TasksApiManager alloc] init] addTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        }];
    }];
    
}

-(void)updateTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] updateTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
       [[[TasksApiManager alloc] init] updateTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
           [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
       }];
    }];
}

-(void)deleteTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] deleteTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
        [[[TasksApiManager alloc] init] deleteTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        }];
    }];

}

-(void) cleanTable
{
    return [[[TasksCoreDataManager alloc] init] cleanTable];
}

@end
