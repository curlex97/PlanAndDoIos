//
//  TasksApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksApplicationManager.h"

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
    [[[TasksApiManager alloc] init] addTaskAsync:task forUser:nil completion:nil];
}

-(void)updateTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] updateTask:task];
    [[[TasksApiManager alloc] init] updateTaskAsync:task forUser:nil completion:nil];
}

-(void)deleteTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] deleteTask:task];
    [[[TasksApiManager alloc] init] deleteTaskAsync:task forUser:nil completion:nil];
}

@end
