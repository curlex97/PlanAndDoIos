//
//  SubTasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksCoreDataManager.h"
#import "ApplicationDefines.h"

@implementation SubTasksCoreDataManager

-(KSShortTask *)subTaskWithId:(int)Id andTaskId:(int)taskId
{
    KSTaskCollection *col = [[KSTaskCollection alloc] init];
    col.ID = taskId;
    for(KSShortTask* sub in [self allSubTasksForTask:col])
        if([sub ID] == Id) return sub;
    return nil;

}

-(NSArray<KSShortTask *> *)allSubTasksForTask:(KSTaskCollection *)task
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            int taskID = [[managedSubtask valueForKey:CD_ROW_TASK_ID] intValue];
            bool del = [[managedSubtask valueForKey:CD_ROW_IS_DELETED] boolValue];

            if(taskID == [task ID] && !del)
            {
                int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
                NSString* name = (NSString*)[managedSubtask valueForKey:CD_ROW_NAME];
                bool status = [[managedSubtask valueForKey:CD_ROW_STATUS] boolValue];
                int syncStatus = [[managedSubtask valueForKey:CD_SUBTASK_SYNC_STATUS] intValue];

                KSShortTask* subtask = [[KSShortTask alloc] initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus];
                [subtasks addObject:subtask];
            }
        }
    }
    
    return subtasks;
}


-(NSArray<KSShortTask *> *)allSubTasksForSyncAdd
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            bool localSync = [[managedSubtask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedSubtask valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
            
            if(!localSync && !del && ID < 0)
            {
                NSString* name = (NSString*)[managedSubtask valueForKey:CD_ROW_NAME];
                bool status = [[managedSubtask valueForKey:CD_ROW_STATUS] boolValue];
                int syncStatus = [[managedSubtask valueForKey:CD_SUBTASK_SYNC_STATUS] intValue];
                
                KSShortTask* subtask = [[KSShortTask alloc] initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus];
                [subtasks addObject:subtask];
            }
        }
    }
    
    return subtasks;
}

-(NSArray<KSShortTask *> *)allSubTasksForSyncUpdate
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            bool localSync = [[managedSubtask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedSubtask valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
            
            if(!localSync && !del && ID >= 0)
            {
                NSString* name = (NSString*)[managedSubtask valueForKey:CD_ROW_NAME];
                bool status = [[managedSubtask valueForKey:CD_ROW_STATUS] boolValue];
                int syncStatus = [[managedSubtask valueForKey:CD_SUBTASK_SYNC_STATUS] intValue];
                
                KSShortTask* subtask = [[KSShortTask alloc] initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus];
                [subtasks addObject:subtask];
            }
        }
    }
    
    return subtasks;
}

-(NSArray<KSShortTask *> *)allSubTasksForSyncDelete
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            bool localSync = [[managedSubtask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedSubtask valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
            
            if(!localSync && del)
            {
                NSString* name = (NSString*)[managedSubtask valueForKey:CD_ROW_NAME];
                bool status = [[managedSubtask valueForKey:CD_ROW_STATUS] boolValue];
                int syncStatus = [[managedSubtask valueForKey:CD_SUBTASK_SYNC_STATUS] intValue];
                
                KSShortTask* subtask = [[KSShortTask alloc] initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus];
                [subtasks addObject:subtask];
            }
        }
    }
    
    return subtasks;
}


-(void)addSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_SUBTASK inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [object setValue:[NSNumber numberWithInt:task.ID] forKey:CD_ROW_TASK_ID];
    [object setValue:[NSNumber numberWithInteger:subTask.ID] forKey:CD_ROW_ID];
    [object setValue:[subTask name] forKey:CD_ROW_NAME];
    [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_SUBTASK_SYNC_STATUS];
    [object setValue:[NSNumber numberWithBool:subTask.status] forKey:CD_ROW_STATUS];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

    [managedObjectContext save:nil];
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            int taskID = [[managedSubtask valueForKey:CD_ROW_TASK_ID] intValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];

            if(taskID == [task ID] && ID == [subTask ID])
            {
                [managedSubtask setValue:[NSNumber numberWithInt:task.ID] forKey:CD_ROW_TASK_ID];
                [managedSubtask setValue:[NSNumber numberWithInt:subTask.ID] forKey:CD_ROW_ID];
                [managedSubtask setValue:[subTask name] forKey:CD_ROW_NAME];
                [managedSubtask setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:CD_SUBTASK_SYNC_STATUS];
                [managedSubtask setValue:[NSNumber numberWithBool:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_STATUS];
                [managedSubtask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
                [managedSubtask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

                [self.managedObjectContext save:nil];
            }
        }
    }
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            int taskID = [[managedSubtask valueForKey:CD_ROW_TASK_ID] intValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
            
            if(taskID == [task ID] && ID == [subTask ID])
            {
                [managedSubtask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_IS_DELETED];
                [managedSubtask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
                [managedSubtask setValue:[NSNumber numberWithBool:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_STATUS];

                [self.managedObjectContext save:nil];
            }
        }
    }
    });
}

-(void)cleanTable
{
    [super cleanTable:CD_TABLE_SUBTASK];
}



// SYNC

-(void)syncAddSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_SUBTASK inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [object setValue:[NSNumber numberWithInt:task.ID] forKey:CD_ROW_TASK_ID];
    [object setValue:[NSNumber numberWithInt:subTask.ID] forKey:CD_ROW_ID];
    [object setValue:[subTask name] forKey:CD_ROW_NAME];
    [object setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:CD_SUBTASK_SYNC_STATUS];
    [object setValue:[NSNumber numberWithBool:subTask.status] forKey:CD_ROW_STATUS];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
    [object setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
    
    [managedObjectContext save:nil];
}

-(void)syncUpdateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            int taskID = [[managedSubtask valueForKey:CD_ROW_TASK_ID] intValue];
            int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
            
            if(taskID == [task ID] && ID == [subTask ID])
            {
                [managedSubtask setValue:[NSNumber numberWithInt:task.ID] forKey:CD_ROW_TASK_ID];
                [managedSubtask setValue:[NSNumber numberWithInt:subTask.ID] forKey:CD_ROW_ID];
                [managedSubtask setValue:[subTask name] forKey:CD_ROW_NAME];
                [managedSubtask setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:CD_SUBTASK_SYNC_STATUS];
                [managedSubtask setValue:[NSNumber numberWithBool:subTask.status] forKey:CD_ROW_STATUS];
                [managedSubtask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
                [managedSubtask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                
                [self.managedObjectContext save:nil];
            }
        }
    }
}

-(void)syncDeleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSError* error = nil;
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SUBTASK];
        NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if(!error)
        {
            for(NSManagedObject* managedSubtask in results)
            {
                int taskID = [[managedSubtask valueForKey:CD_ROW_TASK_ID] intValue];
                int ID = [[managedSubtask valueForKey:CD_ROW_ID] intValue];
                
                if(taskID == [task ID] && ID == [subTask ID])
                {
                    [managedSubtask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_IS_DELETED];
                    [managedSubtask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                    [managedSubtask setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:CD_SUBTASK_SYNC_STATUS];
                    [self.managedObjectContext deleteObject:managedSubtask];
                    [self.managedObjectContext save:nil];
                }
            }
        }
    });
}



@end
