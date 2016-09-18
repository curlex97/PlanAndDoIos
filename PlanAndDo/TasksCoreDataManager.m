//
//  TasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksCoreDataManager.h"

@implementation TasksCoreDataManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(NSArray<BaseTask *> *)allTasks
{
    NSMutableArray<BaseTask*>* tasks = [NSMutableArray array];
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int task_type = [[managedTask valueForKey:@"task_type"] intValue];
            if(!task_type)
            {
                NSUInteger ID = (NSUInteger)[managedTask valueForKey:@"id"];
                NSString* name = (NSString*)[managedTask valueForKey:@"task_name"];
                BOOL status = (BOOL)[managedTask valueForKey:@"is_completed"];
                NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:@"task_reminder_time"];
                KSTaskPriority priority = (int)[managedTask valueForKey:@"task_priority"];
                NSUInteger categoryID = (NSUInteger)[managedTask valueForKey:@"category_id"];
                NSDate* createdAt = (NSDate*)[managedTask valueForKey:@"created_at"];
                NSDate* completionTime = (NSDate*)[managedTask valueForKey:@"task_completion_time"];
                int syncStatus = (int)[managedTask valueForKey:@"task_sync_status"];
                NSString* desc = (NSString*)[managedTask valueForKey:@"task_description"];
                
                KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                
                [tasks addObject:task];
            }
            
            else
            {
                NSUInteger ID = (NSUInteger)[managedTask valueForKey:@"id"];
                NSString* name = (NSString*)[managedTask valueForKey:@"task_name"];
                BOOL status = (BOOL)[managedTask valueForKey:@"is_completed"];
                NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:@"task_reminder_time"];
                KSTaskPriority priority = (int)[managedTask valueForKey:@"task_priority"];
                NSUInteger categoryID = (NSUInteger)[managedTask valueForKey:@"category_id"];
                NSDate* createdAt = (NSDate*)[managedTask valueForKey:@"created_at"];
                NSDate* completionTime = (NSDate*)[managedTask valueForKey:@"task_completion_time"];
                int syncStatus = (int)[managedTask valueForKey:@"task_sync_status"];
                
                KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:[NSMutableArray array]];
                
                [tasks addObject:task];
            }
            
        }
    }
    
    return tasks;
}


-(void)addTask:(BaseTask *)task
{
    
    if([task isKindOfClass:[KSTask class]])
    {
        NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
        KSTask* realTask = (KSTask*)task;
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:@"id"];
        [object setValue:realTask.name forKey:@"task_name"];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:@"is_completed"];
        [object setValue:realTask.taskReminderTime forKey:@"task_reminder_time"];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:@"task_priority"];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:@"category_id"];
        [object setValue:realTask.createdAt forKey:@"created_at"];
        [object setValue:realTask.completionTime forKey:@"task_completion_time"];
        [object setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:@"task_sync_status"];
        [object setValue:realTask.taskDescription forKey:@"task_description"];
        [object setValue:[NSNumber numberWithInteger:0] forKey:@"task_type"];
        [managedObjectContext save:nil];
        
    }
    else if([task isKindOfClass:[KSTaskCollection class]])
    {
        NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
        KSTaskCollection* realTask = (KSTaskCollection*)task;
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:@"id"];
        [object setValue:realTask.name forKey:@"task_name"];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:@"is_completed"];
        [object setValue:realTask.taskReminderTime forKey:@"task_reminder_time"];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:@"task_priority"];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:@"category_id"];
        [object setValue:realTask.createdAt forKey:@"created_at"];
        [object setValue:realTask.completionTime forKey:@"task_completion_time"];
        [object setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:@"task_sync_status"];
        [object setValue:[NSNumber numberWithInteger:1] forKey:@"task_type"];
        [managedObjectContext save:nil];
    }
}




/*
 let managedContext = DataController().managedObjectContext
 let entity =  NSEntityDescription.entityForName("HistoryProduct", inManagedObjectContext:managedContext)
 let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
 person.setValue(product.name, forKey: "name")
 managedContext.save();
 */

@end
