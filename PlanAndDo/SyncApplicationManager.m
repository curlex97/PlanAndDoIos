//
//  SyncApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApplicationManager.h"
#import "ApplicationDefines.h"
#import "UserApplicationManager.h"
#import "FileManager.h"
#import "SettingsApplicationManager.h"
#import "CategoryApplicationManager.h"
#import "TasksApplicationManager.h"
#import "SubTasksApplicationManager.h"

@implementation SyncApplicationManager


+(void) updateLastSyncTime:(int)lst
{
    int fileLst = [[FileManager readLastSyncTimeFromFile] intValue];
    if(lst > fileLst) [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", lst]];
}


-(void)syncWithCompletion:(void (^)(BOOL))completed
{
    [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
    [self syncStatusWithCompletion:^(bool status) {
        
        if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
        self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
        [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
        
        [self syncUserWithCompletion:^(bool status) {
            
            if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
            self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
            [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
            
            [self syncSettingsWithCompletion:^(bool status) {
                
                if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
                
                [self syncCategoriesWithCompletion:^(bool status) {
                    
                    if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                    self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                    [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
                    
                    [self syncTasksWithCompletion:^(bool status) {
                        [[ApplicationManager sharedApplication].notificationManager cancelAllNotifications];
                        NSArray * tasks=[[ApplicationManager sharedApplication].tasksApplicationManager allTasks];
                        for(BaseTask * task in tasks)
                        {
                                           if(task.taskReminderTime.timeIntervalSince1970>[NSDate date].timeIntervalSince1970 && task.taskReminderTime.timeIntervalSince1970<task.completionTime.timeIntervalSince1970-200)
                                           {
                                               [[ApplicationManager sharedApplication].notificationManager addLocalNotificationWithTitle:@"Reminde"
                                                                                                                                 andBody:task.name
                                                                                                                                andImage:nil
                                                                                                                             andFireDate:[NSDate dateWithTimeIntervalSince1970:task.taskReminderTime.timeIntervalSince1970]
                                                                                                                             andUserInfo:@{@"ID":[NSString stringWithFormat:@"%d",task.ID]}
                                                                                                                                  forKey:[NSString stringWithFormat:@"%d",task.ID]];
                                           }

                                           if(task.completionTime.timeIntervalSince1970>[NSDate date].timeIntervalSince1970)
                                           {
                                               [[ApplicationManager sharedApplication].notificationManager addLocalNotificationWithTitle:@"Complete your task"
                                                                                                                                 andBody:task.name
                                                                                                                                andImage:nil
                                                                                                                             andFireDate:task.completionTime
                                                                                                                             andUserInfo:@{@"ID":[NSString stringWithFormat:@"%d",task.ID]}
                                                                                                                                  forKey:[NSString stringWithFormat:@"%d",task.ID]];
                                               
                                               [[ApplicationManager sharedApplication].notificationManager shedulenotificationsForKey:[NSString stringWithFormat:@"%d",task.ID]];
                                           }
                        }
                        if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                        self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                        [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 1]];
                        
                        [self syncSubTasksWithCompletion:^(bool status) {
                            
                            if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                            self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                            [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", self.syncStat]];
                            
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
    [[[UserApiManager alloc] init] syncUserWithCompletion:^(NSDictionary* dictionary)
    {
        if(!dictionary && completed)
        {
            completed(NO);
            return;
        }
        [[[UserApplicationManager alloc] init] recieveUserFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        if(completed) completed(YES);
    }];
}

-(void)syncSettingsWithCompletion:(void (^)(bool))completed
{
    [[[SettingsApiManager alloc] init] syncSettingsWithCompletion:^(NSDictionary* dictionary)
    {
        if(!dictionary && completed)
        {
            completed(NO);
            return;
        }
        [[[SettingsApplicationManager alloc] init] recieveSettingsFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
        if(completed) completed(YES);
    }];
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(NSDictionary* dictionary)
    {
        if(!dictionary && completed)
        {
            completed(NO);
            return;
        }
        [[[CategoryApplicationManager alloc] init] recieveCategoriesFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        if(completed) completed(YES);
    }];
}

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    [[[TasksApiManager alloc] init] syncTasksWithCompletion:^(NSDictionary* dictionary)
    {
        if(!dictionary && completed)
        {
            completed(NO);
            return;
        }
        [[[TasksApplicationManager alloc] init] recieveTasksFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        if(completed) completed(YES);
    }];
}

-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(NSDictionary* dictionary)
    {
        if(!dictionary && completed)
        {
            completed(NO);
            return;
        }
        [[[SubTasksApplicationManager alloc] init] recieveSubTasksFromDictionary:dictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        if(completed) completed(YES);
    }];
}


-(void) syncStatusWithCompletion:(void (^)(bool))completed
{
    
    [[[SyncApiManager alloc] init] syncStatusWithCompletion:^(NSDictionary * dictionary)
     {
         if(!dictionary && completed)
         {
             completed(NO);
             return;
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_STATUS object:nil];
         if(completed) completed(YES);
     }];
}





@end
