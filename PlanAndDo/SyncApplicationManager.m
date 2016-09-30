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
                            completed(true);
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)syncUserWithCompletion:(void (^)(bool))completed
{
    [[[UserApiManager alloc] init] syncUserWithCompletion:^(NSDictionary* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        completed(YES);
    }];
}

-(void)syncSettingsWithCompletion:(void (^)(bool))completed
{
    [[[SettingsApiManager alloc] init] syncSettingsWithCompletion:^(NSDictionary* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
        completed(YES);
    }];
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(NSDictionary* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        completed(YES);
    }];
}

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    [[[TasksApiManager alloc] init] syncTasksWithCompletion:^(NSDictionary* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        completed(YES);
    }];
}

-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(NSDictionary* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        completed(YES);
    }];
}


-(void) syncStatusWithCompletion:(void (^)(bool))completed
{
    
    [[[SyncApiManager alloc] init] syncStatusWithUser:[[[UserApplicationManager alloc] init] authorisedUser] andCompletion:^(NSDictionary * json)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_STATUS object:nil];
        completed(YES);
    }];
}





@end
