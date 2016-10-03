//
//  TasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksCoreDataManager.h"
#import "SubTasksCoreDataManager.h"

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
            bool del = [[managedTask valueForKey:@"is_deleted"] boolValue];
            
            if(!del)
            {
                if(!task_type)
                {
                    NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
                    NSString* name = (NSString*)[managedTask valueForKey:@"task_name"];
                    BOOL status = [[managedTask valueForKey:@"is_completed"] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:@"task_reminder_time"];
                    KSTaskPriority priority = [[managedTask valueForKey:@"task_priority"] intValue];
                    int categoryID = [[managedTask valueForKey:@"category_id"] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:@"created_at"];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:@"task_completion_time"];
                    int syncStatus = [[managedTask valueForKey:@"task_sync_status"] intValue];
                    NSString* desc = (NSString*)[managedTask valueForKey:@"task_description"];
                    
                    KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                    
                    [tasks addObject:task];
                }
                
                else
                {
                    NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
                    NSString* name = (NSString*)[managedTask valueForKey:@"task_name"];
                    BOOL status = [[managedTask valueForKey:@"is_completed"] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:@"task_reminder_time"];
                    KSTaskPriority priority = [[managedTask valueForKey:@"task_priority"] intValue];
                    int categoryID = [[managedTask valueForKey:@"category_id"] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:@"created_at"];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:@"task_completion_time"];
                    int syncStatus = [[managedTask valueForKey:@"task_sync_status"] intValue];
                    KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:nil];
                    task.subTasks = [NSMutableArray arrayWithArray:[[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task]];
                    
                    [tasks addObject:task];
                }
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
           [components day] == [taskComponents day] && ![task status])
            [tasks addObject:task];
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
        if([task completionTime] == nil || [task categoryID] <= 0) [tasks addObject:task];
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
        [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"task_sync_status"];
        [object setValue:realTask.taskDescription forKey:@"task_description"];
        [object setValue:[NSNumber numberWithInteger:0] forKey:@"task_type"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
        [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"task_sync_status"];
        [object setValue:[NSNumber numberWithInteger:1] forKey:@"task_type"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
            NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
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
                    [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"task_sync_status"];
                    [managedTask setValue:realTask.taskDescription forKey:@"task_description"];
                    [managedTask setValue:[NSNumber numberWithInteger:0] forKey:@"task_type"];
                    [managedTask setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
                    [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"task_sync_status"];
                    [managedTask setValue:[NSNumber numberWithInteger:1] forKey:@"task_type"];
                    [managedTask setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
            NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
            if(ID == [task ID])
            {
                [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [managedTask setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
                [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"task_sync_status"];

                [self.managedObjectContext save:nil];
                return;
            }
        }
    }

}


-(void)cleanTable
{
    [super cleanTable:@"Task"];
}

// SYNC

-(void)syncAddTask:(BaseTask *)task
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
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
        
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
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
        
        [managedObjectContext save:nil];
    }
}


-(void)syncUpdateTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
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
                    [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                    
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
                    [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                    
                    [self.managedObjectContext save:nil];
                }
                return;
            }
            
        }
    }
}


-(void)syncDeleteTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            NSUInteger ID = [[managedTask valueForKey:@"id"] integerValue];
            if(ID == [task ID])
            {
                [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [managedTask setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                [managedTask setValue:[NSNumber numberWithInteger:task.syncStatus] forKey:@"task_sync_status"];
                
                [self.managedObjectContext save:nil];
                return;
            }
        }
    }
    
}


@end
