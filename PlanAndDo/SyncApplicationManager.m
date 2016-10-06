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


+(void) updateLastSyncTime:(int)lst
{
    int fileLst = [[FileManager readLastSyncTimeFromFile] intValue];
    if(lst > fileLst) [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", lst]];
}


-(void)syncWithCompletion:(void (^)(BOOL))completed
{
    
    
    [self syncStatusWithCompletion:^(bool status) {
        
        if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
        self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
        [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 0]];
        
        [self syncUserWithCompletion:^(bool status) {
            
            if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
            self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
            [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 0]];
            
            [self syncSettingsWithCompletion:^(bool status) {
                
                if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 0]];
                
                [self syncCategoriesWithCompletion:^(bool status) {
                    
                    if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                    self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                    [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 0]];
                    
                    [self syncTasksWithCompletion:^(bool status) {
                        
                        if([[FileManager readLastSyncTimeFromFile] intValue] > self.syncStat)
                        self.syncStat = [[FileManager readLastSyncTimeFromFile] intValue];
                        [FileManager writeLastSyncTimeToFile:[NSString stringWithFormat:@"%i", 0]];
                        
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
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(NSDictionary* dictionary) {
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
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(NSDictionary* dictionary) {
        [[[SubTasksApplicationManager alloc] init] recieveSubTasksFromDictionary:dictionary];
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
