//
//  SubTasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksCoreDataManager.h"

@implementation SubTasksCoreDataManager

-(NSArray<KSShortTask *> *)allSubTasksForTask:(KSTaskCollection *)task
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subtask"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            NSUInteger taskID = [[managedSubtask valueForKey:@"task_id"] integerValue];
            bool del = [[managedSubtask valueForKey:@"is_deleted"] boolValue];

            if(taskID == [task ID] && !del)
            {
                NSUInteger ID = [[managedSubtask valueForKey:@"id"] integerValue];
                NSString* name = (NSString*)[managedSubtask valueForKey:@"name"];
                bool status = [[managedSubtask valueForKey:@"status"] boolValue];
                int syncStatus = [[managedSubtask valueForKey:@"subtask_sync_status"] intValue];

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
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Subtask" inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [object setValue:[NSNumber numberWithInteger:task.ID] forKey:@"task_id"];
    [object setValue:[NSNumber numberWithInteger:subTask.ID] forKey:@"id"];
    [object setValue:[subTask name] forKey:@"name"];
    [object setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:@"subtask_sync_status"];
    [object setValue:[NSNumber numberWithBool:subTask.status] forKey:@"status"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
    
    [managedObjectContext save:nil];
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subtask"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            NSUInteger taskID = [[managedSubtask valueForKey:@"task_id"] integerValue];
            NSUInteger ID = [[managedSubtask valueForKey:@"id"] integerValue];

            if(taskID == [task ID] && ID == [subTask ID])
            {
                [managedSubtask setValue:[NSNumber numberWithInteger:task.ID] forKey:@"task_id"];
                [managedSubtask setValue:[NSNumber numberWithInteger:subTask.ID] forKey:@"id"];
                [managedSubtask setValue:[subTask name] forKey:@"name"];
                [managedSubtask setValue:[NSNumber numberWithInteger:subTask.syncStatus] forKey:@"subtask_sync_status"];
                [managedSubtask setValue:[NSNumber numberWithBool:subTask.status] forKey:@"status"];
                [managedSubtask setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
                
                [self.managedObjectContext save:nil];
            }
        }
    }
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Subtask"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSubtask in results)
        {
            NSUInteger taskID = [[managedSubtask valueForKey:@"task_id"] integerValue];
            NSUInteger ID = [[managedSubtask valueForKey:@"id"] integerValue];
            
            if(taskID == [task ID] && ID == [subTask ID])
            {
                [managedSubtask setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [self.managedObjectContext save:nil];
            }
        }
    }
}


@end
