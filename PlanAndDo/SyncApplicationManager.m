//
//  SyncApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApplicationManager.h"
#import "ApplicationDefines.h"
#import "UserApplicationManager.h"
#import "FileManager.h"
#import "SettingsApplicationManager.h"
#import "CategoryApplicationManager.h"
#import "TasksApplicationManager.h"
#import "SubTasksApplicationManager.h"

@implementation SyncApplicationManager

-(void)syncWithCompletion:(void (^)(bool))completed
{
    [self syncStatusWithCompletion:^(bool status) {
        [self syncUserWithCompletion:^(bool status) {
            [self syncSettingsWithCompletion:^(bool status) {
                [self syncCategoriesWithCompletion:^(bool status) {
                    [self syncTasksWithCompletion:^(bool status) {
                        [self syncSubTasksWithCompletion:^(bool status) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_COMPLETED object:nil];
                            if(completed) completed(true);
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)syncUserWithCompletion:(void (^)(bool))completed
{
    [[[UserApiManager alloc] init] syncUserWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            NSUInteger ID = [[dictionary valueForKeyPath:@"data.id"] integerValue];
            NSString* userName = [dictionary valueForKeyPath:@"data.name"];
            int syncStatus = [[dictionary valueForKeyPath:@"data.user_sync_status"] intValue];
            NSString* email = [dictionary valueForKeyPath:@"data.email"];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.created_at"] intValue]];
            NSDate *lastVisitDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.lastvisit_date"] intValue]];

            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisitDate andSyncStatus:syncStatus andAccessToken:[FileManager readTokenFromFile] andUserSettings:nil];
            
            KSAuthorisedUser* localUser = [[[UserCoreDataManager alloc] init] authorisedUser];
            
            if(!localUser)[[[UserCoreDataManager alloc] init] syncSetUser:user];
            else if(localUser.syncStatus < user.syncStatus) [[[UserCoreDataManager alloc] init] syncUpdateUser:user];
            
            if(completed) completed(true);
        }
        if(completed) completed(false);
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
    
    }];
}

-(void)syncSettingsWithCompletion:(void (^)(bool))completed
{
    [[[SettingsApiManager alloc] init] syncSettingsWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
        
            NSUInteger settingsID = [[dictionary valueForKeyPath:@"data.id"] integerValue];
            NSString* startPage = [dictionary valueForKeyPath:@"data.start_page"];
            NSString* dateFormat = [dictionary valueForKeyPath:@"data.date_format"];
            NSString* timeFormat = [dictionary valueForKeyPath:@"data.time_format"];
            NSString* pageType = [dictionary valueForKeyPath:@"data.page_type"];
            NSString* startDay = [dictionary valueForKeyPath:@"data.start_day"];
            int syncStatus = [[dictionary valueForKeyPath:@"data.settings_sync_status"] intValue];
            
            UserSettings *settings = [[UserSettings alloc] initWithID:settingsID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
            
            UserSettings* localSettings = [[[SettingsCoreDataManager alloc] init] settings];
            
            if(!localSettings) [[[SettingsCoreDataManager alloc] init] syncSetSettings:settings];
            else if(localSettings.syncStatus < settings.syncStatus) [[[SettingsCoreDataManager alloc] init] syncUpdateSettings:settings];
            
            if(completed) completed(true);
        }
        if(completed) completed(false);
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
    }];
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
        
            NSArray* defCats = (NSArray*)[dictionary valueForKeyPath:@"data"];
            
            for(NSDictionary* defaultCategory in defCats)
            {
                NSUInteger catID = [[defaultCategory valueForKeyPath:@"id"] integerValue];
                NSString* catName = [defaultCategory valueForKeyPath:@"category_name"];
                int catSyncStatus = [[defaultCategory valueForKeyPath:@"category_sync_status"] intValue];
                
                bool isDeleted = [[defaultCategory valueForKeyPath:@"is_deleted"] intValue] > 0;
                
                KSCategory* category = [[KSCategory alloc] initWithID:catID andName:catName andSyncStatus:catSyncStatus];
                
                KSCategory* localCategory = [[[CategoryCoreDataManager alloc] init] categoryWithId:(int)category.ID];
                
                
                if(!isDeleted)
                {
                    if(!localCategory)
                        [[[CategoryCoreDataManager alloc] init] syncAddCateroty:category];
        
                    else if(localCategory.syncStatus < category.syncStatus)
                            [[[CategoryCoreDataManager alloc] init] syncUpdateCateroty:category];
                }
                else [[[CategoryCoreDataManager alloc] init] syncDeleteCateroty:category];
                
                
            }
            if(completed) completed(true);
        }
        if(completed) completed(false);
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
    }];
}

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    [[[TasksApiManager alloc] init] syncTasksWithCompletion:^(NSDictionary* dictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            
            NSArray* tasks = (NSArray*)[dictionary valueForKeyPath:@"data"];
            
            for(NSDictionary* jsonTask in tasks)
            {
                NSUInteger taskID = [[jsonTask valueForKeyPath:@"id"] integerValue];
                NSUInteger categoryID = 0;
                if(![[jsonTask valueForKeyPath:@"category_id"] isKindOfClass:[NSNull class]])
                    categoryID = [[jsonTask valueForKeyPath:@"category_id"] integerValue];
                bool taskType = [[jsonTask valueForKeyPath:@"task_type"] integerValue] > 0;
                NSString* name = [jsonTask valueForKeyPath:@"task_name"];
                NSString* desc = [jsonTask valueForKeyPath:@"task_description"];
                NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"created_at"] intValue]];
                NSDate *reminderTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"task_reminder_time"] intValue]];
                NSUInteger taskPriority = [[jsonTask valueForKeyPath:@"task_priority"] integerValue];
                bool status = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"created_at"] intValue]] > 0;
                NSDate *completionTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"task_completion_time"] intValue]];
                int syncStatus = [[jsonTask valueForKeyPath:@"task_sync_status"] intValue];
                bool isDeleted = [[jsonTask valueForKeyPath:@"is_deleted"] intValue] > 0;

                
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
            if(completed) completed(true);
        }
        if(completed) completed(false);
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
    }];
}

-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(NSDictionary* dictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        if(completed) completed(YES);
    }];
}


-(void) syncStatusWithCompletion:(void (^)(bool))completed
{
    
    [[[SyncApiManager alloc] init] syncStatusWithCompletion:^(NSDictionary * dictionary)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_STATUS object:nil];
         if(completed) completed(YES);
     }];
}





@end
