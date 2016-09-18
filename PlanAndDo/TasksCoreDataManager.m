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


-(BaseTask *)taskWithId:(int)Id
{
    for(BaseTask* task in [self allTasks])
        if([task ID] == Id) return task;
    return nil;
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

-(NSArray<BaseTask *> *)allTasksForCategory:(KSCategory *)category
{
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
        if([task categoryID] == [category ID]) [tasks addObject:task];
    
    return tasks;
}

-(NSArray<BaseTask *> *)allTasksForToday
{
    NSDate* date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
    {
        NSDateComponents *taskComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[task completionTime]];
        
        if([components year] == [taskComponents year] &&
           [components month] == [taskComponents month] &&
           [components day] == [taskComponents day] && ![task status]) [tasks addObject:task];
    }
    
    
    return tasks;
}

-(NSArray<BaseTask *> *)allTasksForTomorrow
{
    NSDate* date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
    {
        NSDateComponents *taskComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[task completionTime]];
        
        if([components year] == [taskComponents year] &&
           [components month] == [taskComponents month] &&
           [components day] == [taskComponents day] && ![task status]) [tasks addObject:task];
    }
    
    
    return tasks;
}

-(NSArray<BaseTask *> *)allTasksForWeek
{
    NSDate* date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
    {
        NSDateComponents *taskComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[task completionTime]];
        
        if([components year] == [taskComponents year] &&
           [components month] == [taskComponents month] &&
           [taskComponents day] - [components day]  < 7 && ![task status]) [tasks addObject:task];
    }
    
    
    return tasks;

}

-(NSArray<BaseTask *> *)allTasksForArchive
{
    NSDate* date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
    {
        NSDateComponents *taskComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[task completionTime]];
        
        if([components year] > [taskComponents year] ||
           [components month] > [taskComponents month] ||
           [components day] > [taskComponents day] ||
           [task status]) [tasks addObject:task];
    }
    
    return tasks;
}


-(NSArray<BaseTask *> *)allTasksForBacklog
{
    NSMutableArray* tasks = [NSMutableArray array];
    
    for(BaseTask* task in [self allTasks])
    {
        if([task completionTime] == nil || [task categoryID] == 0) [tasks addObject:task];
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


-(void)updateTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            NSUInteger ID = (NSUInteger)[managedTask valueForKey:@"id"];
            if(ID == [task ID])
            {
                if([task isKindOfClass:[KSTask class]])
                {
                    KSTask* realTask = (KSTask*)task;
                    
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:@"id"];
                    [managedTask setValue:realTask.name forKey:@"task_name"];
                    [managedTask setValue:[NSNumber numberWithBool:task.status] forKey:@"is_completed"];
                    [managedTask setValue:realTask.taskReminderTime forKey:@"task_reminder_time"];
                    [managedTask setValue:[NSNumber numberWithInteger:task.priority] forKey:@"task_priority"];
                    [managedTask setValue:[NSNumber numberWithInteger:task.categoryID] forKey:@"category_id"];
                    [managedTask setValue:realTask.createdAt forKey:@"created_at"];
                    [managedTask setValue:realTask.completionTime forKey:@"task_completion_time"];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:@"task_sync_status"];
                    [managedTask setValue:realTask.taskDescription forKey:@"task_description"];
                    [managedTask setValue:[NSNumber numberWithInteger:0] forKey:@"task_type"];
                    [self.managedObjectContext save:nil];
                    
                }
                else if([task isKindOfClass:[KSTaskCollection class]])
                {
                    KSTaskCollection* realTask = (KSTaskCollection*)task;

                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:@"id"];
                    [managedTask setValue:realTask.name forKey:@"task_name"];
                    [managedTask setValue:[NSNumber numberWithBool:realTask.status] forKey:@"is_completed"];
                    [managedTask setValue:realTask.taskReminderTime forKey:@"task_reminder_time"];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.priority] forKey:@"task_priority"];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:@"category_id"];
                    [managedTask setValue:realTask.createdAt forKey:@"created_at"];
                    [managedTask setValue:realTask.completionTime forKey:@"task_completion_time"];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:@"task_sync_status"];
                    [managedTask setValue:[NSNumber numberWithInteger:1] forKey:@"task_type"];
                    [self.managedObjectContext save:nil];
                }
                return;
            }
            
        }
    }
}


-(void) deleteTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            NSUInteger ID = (NSUInteger)[managedTask valueForKey:@"id"];
            if(ID == [task ID])
            {
                [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [self.managedObjectContext save:nil];
                return;
            }
        }
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
