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

-(void)addSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task completion:(void (^)(bool))completed
{
    if(subTask.ID > 0) subTask.ID = -subTask.ID;
    
    [[[SubTasksCoreDataManager alloc] init] addSubTask:subTask forTask:task];
    [[[SyncApplicationManager alloc] init]syncSubTasksWithCompletion:^(bool status)
    {
        if(status)
        {
            [[[SubTasksApiManager alloc] init] addSubTasksAsync:@[subTask] toTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
                
                if([[dictionary valueForKeyPath:@"status"] containsString:@"suc"])
                        [[ApplicationManager subTasksApplicationManager] deleteSubTask:subTask forTask:task completion:nil];
                
                
            [self recieveSubTasksFromDictionary:dictionary];
                if(completed) completed(YES);
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
            }];
        }
    }];
    
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task completion:(void (^)(bool))completed
{
    [[[SubTasksCoreDataManager alloc] init] updateSubTask:subTask forTask:task];
    [[[SyncApplicationManager alloc] init] syncSubTasksWithCompletion:^(bool status)
     {
         if(status)
         {
             [[[SubTasksApiManager alloc] init] updateSubTasksAsync:@[subTask] inTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
                 
                 [self recieveSubTasksFromDictionary:dictionary];
                 if(completed) completed(YES);
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
             }];
         }
    }];
    
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task completion:(void (^)(bool))completed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
    [[[SubTasksCoreDataManager alloc] init] deleteSubTask:subTask forTask:task];
    [[[SyncApplicationManager alloc] init] syncSubTasksWithCompletion:^(bool status)
    {
        if(status)
        {
            [[[SubTasksApiManager alloc] init] deleteSubTasksAsync:@[subTask] fromTask:task forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
                
                [self recieveSubTasksFromDictionary:dictionary];
                if(completed) completed(YES);
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
            }];
        }
    }];
    });
}

-(void)recieveSubTasksFromDictionary:(NSDictionary *)dictionary
{
    NSString* status = [dictionary valueForKeyPath:@"status"];
    
    if([status containsString:@"suc"])
    {
        
        NSArray* subs = (NSArray*)[dictionary valueForKeyPath:@"data"];
        
        for(NSDictionary* jsonSub in subs)
        {
            int subID = [[jsonSub valueForKeyPath:@"id"] intValue];
            int taskID = [[jsonSub valueForKeyPath:@"task_id"] intValue];
            NSString* subName = [jsonSub valueForKeyPath:@"name"];
            int syncStatus = [[jsonSub valueForKeyPath:@"subtask_sync_status"] intValue];
            bool isCompleted = [[jsonSub valueForKeyPath:@"is_completed"] integerValue] > 0;
            bool isDeleted = [[jsonSub valueForKeyPath:@"is_deleted"] intValue] > 0;
            
            [SyncApplicationManager updateLastSyncTime:syncStatus];
            
            KSShortTask* sub = [[KSShortTask alloc] initWithID:subID andName:subName andStatus:isCompleted andSyncStatus:syncStatus];
            KSShortTask* localSub = [[[SubTasksCoreDataManager alloc] init] subTaskWithId:(int)subID andTaskId:(int)taskID];
            KSTaskCollection* col = [[KSTaskCollection alloc] init];
            col.ID = taskID;
            
            if(!isDeleted)
            {
                if(!localSub)
                    [[[SubTasksCoreDataManager alloc] init] syncAddSubTask:sub forTask:col];
                else if(localSub.syncStatus < sub.syncStatus)
                    [[[SubTasksCoreDataManager alloc] init] syncUpdateSubTask:sub forTask:col];
            }
            else
                [[[SubTasksCoreDataManager alloc] init] syncDeleteSubTask:sub forTask:col];
        }
    }
}

-(void) cleanTable
{
    return [[[SubTasksCoreDataManager alloc] init] cleanTable];
}

@end
