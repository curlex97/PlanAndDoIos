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
    if(task.ID > 0) task.ID = -task.ID;
    
    [[[TasksCoreDataManager alloc] init] addTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
        [[[TasksApiManager alloc] init] addTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSyncAdd] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [self recieveTasksFromDictionary:dictionary];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        }];

    }];
    
}

-(void)updateTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] updateTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
       [[[TasksApiManager alloc] init] updateTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSyncUpdate] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
           [self recieveTasksFromDictionary:dictionary];
           [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
       }];
    }];
}

-(void)deleteTask:(BaseTask *)task
{
    [[[TasksCoreDataManager alloc] init] deleteTask:task];
    [[[SyncApplicationManager alloc] init] syncTasksWithCompletion:^(bool status) {
        [[[TasksApiManager alloc] init] deleteTasksAsync:[[[TasksCoreDataManager alloc] init] allTasksForSyncDelete] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [self recieveTasksFromDictionary:dictionary];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        }];
    }];

}

-(void) recieveTasksFromDictionary:(NSDictionary*)dictionary
{
    NSString* status = [dictionary valueForKeyPath:@"status"];
    
    if([status containsString:@"suc"])
    {
        
        NSArray* tasks = (NSArray*)[dictionary valueForKeyPath:@"data"];
        
        for(NSDictionary* jsonTask in tasks)
        {
            int taskID = [[jsonTask valueForKeyPath:@"id"] intValue];
            NSUInteger categoryID = 0;
            if(![[jsonTask valueForKeyPath:@"category_id"] isKindOfClass:[NSNull class]])
                categoryID = [[jsonTask valueForKeyPath:@"category_id"] integerValue];
            bool taskType = [[jsonTask valueForKeyPath:@"task_type"] integerValue] > 0;
            NSString* name = [jsonTask valueForKeyPath:@"task_name"];
            NSString* desc = @"";
            if([[jsonTask valueForKeyPath:@"task_description"] isKindOfClass:[NSNull class]])
            [jsonTask valueForKeyPath:@"task_description"];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"created_at"] intValue]];
            NSDate *reminderTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"task_reminder_time"] intValue]];
            NSUInteger taskPriority = [[jsonTask valueForKeyPath:@"task_priority"] integerValue];
            bool status = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"created_at"] intValue]] > 0;
            NSDate *completionTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"task_completion_time"] intValue]];
            int syncStatus = [[jsonTask valueForKeyPath:@"task_sync_status"] intValue];
            bool isDeleted = [[jsonTask valueForKeyPath:@"is_deleted"] intValue] > 0;
            
            [SyncApplicationManager updateLastSyncTime:syncStatus];
            
            BaseTask* task = !taskType ? [[KSTask alloc] initWithID:taskID andName:name andStatus:status andTaskReminderTime:reminderTime andTaskPriority:taskPriority andCategoryID:(int)categoryID andCreatedAt:createDate andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc] :
            [[KSTaskCollection alloc] initWithID:taskID andName:name andStatus:status andTaskReminderTime:reminderTime andTaskPriority:taskPriority andCategoryID:(int)categoryID andCreatedAt:createDate andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:nil];
            
            BaseTask* localTask = [[[TasksCoreDataManager alloc] init] taskWithId:(int)taskID];
            
            if(!isDeleted)
            {
                if(!localTask)
                    [[[TasksCoreDataManager alloc] init] syncAddTask:task];
                
                else if(localTask.syncStatus < task.syncStatus)
                    [[[TasksCoreDataManager alloc] init] syncUpdateTask:task];
            }
            else [[[TasksCoreDataManager alloc] init] syncDeleteTask:task];
            
        }
    }
}

-(void) cleanTable
{
    return [[[TasksCoreDataManager alloc] init] cleanTable];
}

@end
