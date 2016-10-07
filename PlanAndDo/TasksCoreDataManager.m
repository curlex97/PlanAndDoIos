//
//  TasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksCoreDataManager.h"
#import "SubTasksCoreDataManager.h"
#import "ApplicationDefines.h"

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
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int task_type = [[managedTask valueForKey:CD_ROW_TASK_TYPE] intValue];
            bool del = [[managedTask valueForKey:CD_ROW_IS_DELETED] boolValue];
            
            if(!del)
            {
                if(!task_type)
                {
                    int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    NSString* desc = (NSString*)[managedTask valueForKey:CD_ROW_TASK_DESCRIPTION];
                    
                    KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                    
                    [tasks addObject:task];
                }
                
                else
                {
                    int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:nil];
                    task.subTasks = [NSMutableArray arrayWithArray:[[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task]];
                    
                    [tasks addObject:task];
                }
            }
            
        }
    }
    
    return tasks;
}

-(NSArray<BaseTask *> *)allTasksForSyncAdd
{
    NSMutableArray<BaseTask*>* tasks = [NSMutableArray array];
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int task_type = [[managedTask valueForKey:CD_ROW_TASK_TYPE] intValue];
            bool localSync = [[managedTask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            bool del = [[managedTask valueForKey:CD_ROW_IS_DELETED] boolValue];

            if(!localSync && !del && ID < 0)
            {
                if(!task_type)
                {
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    NSString* desc = (NSString*)[managedTask valueForKey:CD_ROW_TASK_DESCRIPTION];
                    
                    KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                    
                    [tasks addObject:task];
                }
                
                else
                {
                    int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:nil];
                    task.subTasks = [NSMutableArray arrayWithArray:[[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task]];
                    
                    [tasks addObject:task];
                }
            }
            
        }
    }
    
    return tasks;
}


-(NSArray<BaseTask *> *)allTasksForSyncUpdate
{
    NSMutableArray<BaseTask*>* tasks = [NSMutableArray array];
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int task_type = [[managedTask valueForKey:CD_ROW_TASK_TYPE] intValue];
            bool localSync = [[managedTask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            bool del = [[managedTask valueForKey:CD_ROW_IS_DELETED] boolValue];
            
            if(!localSync && !del && ID >= 0)
            {
                if(!task_type)
                {
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    NSString* desc = (NSString*)[managedTask valueForKey:CD_ROW_TASK_DESCRIPTION];
                    
                    KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                    
                    [tasks addObject:task];
                }
                
                else
                {
                    int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andSubTasks:nil];
                    task.subTasks = [NSMutableArray arrayWithArray:[[[SubTasksCoreDataManager alloc] init] allSubTasksForTask:task]];
                    
                    [tasks addObject:task];
                }
            }
            
        }
    }
    
    return tasks;
}



-(NSArray<BaseTask *> *)allTasksForSyncDelete
{
    NSMutableArray<BaseTask*>* tasks = [NSMutableArray array];
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int task_type = [[managedTask valueForKey:CD_ROW_TASK_TYPE] intValue];
            bool localSync = [[managedTask valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            bool del = [[managedTask valueForKey:CD_ROW_IS_DELETED] boolValue];
            
            if(!localSync && del)
            {
                if(!task_type)
                {
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
                    NSString* desc = (NSString*)[managedTask valueForKey:CD_ROW_TASK_DESCRIPTION];
                    
                    KSTask* task = [[KSTask alloc] initWithID:ID andName:name andStatus:status andTaskReminderTime:taskRemindeTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus andTaskDescription:desc];
                    
                    [tasks addObject:task];
                }
                
                else
                {
                    int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
                    NSString* name = (NSString*)[managedTask valueForKey:CD_ROW_TASK_NAME];
                    BOOL status = [[managedTask valueForKey:CD_ROW_IS_COMPLETED] boolValue];
                    NSDate* taskRemindeTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_REMINDER_TIME];
                    KSTaskPriority priority = [[managedTask valueForKey:CD_ROW_TASK_PRIORITY] intValue];
                    int categoryID = [[managedTask valueForKey:CD_ROW_CATEGORY_ID] intValue];
                    NSDate* createdAt = (NSDate*)[managedTask valueForKey:CD_ROW_CREATED_AT];
                    NSDate* completionTime = (NSDate*)[managedTask valueForKey:CD_ROW_TASK_COMPLETION_TIME];
                    int syncStatus = [[managedTask valueForKey:CD_ROW_TASK_SYNC_STATUS] intValue];
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
        NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_TASK inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
        [object setValue:realTask.name forKey:CD_ROW_TASK_NAME];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
        [object setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
        [object setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
        [object setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
        [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_TASK_SYNC_STATUS];
        [object setValue:realTask.taskDescription forKey:CD_ROW_TASK_DESCRIPTION];
        [object setValue:[NSNumber numberWithInteger:0] forKey:CD_ROW_TASK_TYPE];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

        [managedObjectContext save:nil];
                
    }
    else if([task isKindOfClass:[KSTaskCollection class]])
    {
        NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
        KSTaskCollection* realTask = (KSTaskCollection*)task;
        NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_TASK inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
        [object setValue:realTask.name forKey:CD_ROW_TASK_NAME];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
        [object setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
        [object setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
        [object setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
        [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_TASK_SYNC_STATUS];
        [object setValue:[NSNumber numberWithInteger:1] forKey:CD_ROW_TASK_TYPE];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

        [managedObjectContext save:nil];
    }
}


-(void)updateTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            if(ID == [task ID])
            {
                if([task isKindOfClass:[KSTask class]])
                {
                    KSTask* realTask = (KSTask*)task;
                    
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
                    [managedTask setValue:realTask.name forKey:CD_ROW_TASK_NAME];
                    [managedTask setValue:[NSNumber numberWithBool:task.status] forKey:CD_ROW_IS_COMPLETED];
                    [managedTask setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:task.priority] forKey:CD_ROW_TASK_PRIORITY];
                    [managedTask setValue:[NSNumber numberWithInteger:task.categoryID] forKey:CD_ROW_CATEGORY_ID];
                    [managedTask setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
                    [managedTask setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_TASK_SYNC_STATUS];
                    [managedTask setValue:realTask.taskDescription forKey:CD_ROW_TASK_DESCRIPTION];
                    [managedTask setValue:[NSNumber numberWithInteger:0] forKey:CD_ROW_TASK_TYPE];
                    [managedTask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

                    [self.managedObjectContext save:nil];
                    
                }
                else if([task isKindOfClass:[KSTaskCollection class]])
                {
                    KSTaskCollection* realTask = (KSTaskCollection*)task;

                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
                    [managedTask setValue:realTask.name forKey:CD_ROW_TASK_NAME];
                    [managedTask setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
                    [managedTask setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
                    [managedTask setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
                    [managedTask setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_TASK_SYNC_STATUS];
                    [managedTask setValue:[NSNumber numberWithInteger:1] forKey:CD_ROW_TASK_TYPE];
                    [managedTask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

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
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            if(ID == [task ID])
            {
                [managedTask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_IS_DELETED];
                [managedTask setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
                [managedTask setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_TASK_SYNC_STATUS];

                [self.managedObjectContext save:nil];
                return;
            }
        }
    }

}


-(void)cleanTable
{
    [super cleanTable:CD_TABLE_TASK];
}

// SYNC

-(void)syncAddTask:(BaseTask *)task
{
    
    if([task isKindOfClass:[KSTask class]])
    {
        NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
        KSTask* realTask = (KSTask*)task;
        NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_TASK inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
        [object setValue:realTask.name forKey:CD_ROW_TASK_NAME];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
        [object setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
        [object setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
        [object setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:CD_ROW_TASK_SYNC_STATUS];
        [object setValue:realTask.taskDescription forKey:CD_ROW_TASK_DESCRIPTION];
        [object setValue:[NSNumber numberWithInteger:0] forKey:CD_ROW_TASK_TYPE];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
        
        [managedObjectContext save:nil];
        
    }
    else if([task isKindOfClass:[KSTaskCollection class]])
    {
        NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
        KSTaskCollection* realTask = (KSTaskCollection*)task;
        NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_TASK inManagedObjectContext:managedObjectContext];
        NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [object setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
        [object setValue:realTask.name forKey:CD_ROW_TASK_NAME];
        [object setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
        [object setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
        [object setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
        [object setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
        [object setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
        [object setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:CD_ROW_TASK_SYNC_STATUS];
        [object setValue:[NSNumber numberWithInteger:1] forKey:CD_ROW_TASK_TYPE];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
        [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
        
        [managedObjectContext save:nil];
    }
}


-(void)syncUpdateTask:(BaseTask *)task
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            if(ID == [task ID])
            {
                if([task isKindOfClass:[KSTask class]])
                {
                    KSTask* realTask = (KSTask*)task;
                    
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
                    [managedTask setValue:realTask.name forKey:CD_ROW_TASK_NAME];
                    [managedTask setValue:[NSNumber numberWithBool:task.status] forKey:CD_ROW_IS_COMPLETED];
                    [managedTask setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:task.priority] forKey:CD_ROW_TASK_PRIORITY];
                    [managedTask setValue:[NSNumber numberWithInteger:task.categoryID] forKey:CD_ROW_CATEGORY_ID];
                    [managedTask setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
                    [managedTask setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:CD_ROW_TASK_SYNC_STATUS];
                    [managedTask setValue:realTask.taskDescription forKey:CD_ROW_TASK_DESCRIPTION];
                    [managedTask setValue:[NSNumber numberWithInteger:0] forKey:CD_ROW_TASK_TYPE];
                    [managedTask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                    
                    [self.managedObjectContext save:nil];
                    
                }
                else if([task isKindOfClass:[KSTaskCollection class]])
                {
                    KSTaskCollection* realTask = (KSTaskCollection*)task;
                    
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.ID] forKey:CD_ROW_ID];
                    [managedTask setValue:realTask.name forKey:CD_ROW_TASK_NAME];
                    [managedTask setValue:[NSNumber numberWithBool:realTask.status] forKey:CD_ROW_IS_COMPLETED];
                    [managedTask setValue:realTask.taskReminderTime forKey:CD_ROW_TASK_REMINDER_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.priority] forKey:CD_ROW_TASK_PRIORITY];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.categoryID] forKey:CD_ROW_CATEGORY_ID];
                    [managedTask setValue:realTask.createdAt forKey:CD_ROW_CREATED_AT];
                    [managedTask setValue:realTask.completionTime forKey:CD_ROW_TASK_COMPLETION_TIME];
                    [managedTask setValue:[NSNumber numberWithInteger:realTask.syncStatus] forKey:CD_ROW_TASK_SYNC_STATUS];
                    [managedTask setValue:[NSNumber numberWithInteger:1] forKey:CD_ROW_TASK_TYPE];
                    [managedTask setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                    
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
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_TASK];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedTask in results)
        {
            int ID = [[managedTask valueForKey:CD_ROW_ID] intValue];
            if(ID == [task ID])
            {
                [self.managedObjectContext deleteObject:managedTask];
                [self.managedObjectContext save:nil];
                return;
            }
        }
    }
    
}


@end
