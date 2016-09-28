//
//  SyncApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApplicationManager.h"

@implementation SyncApplicationManager

-(void)syncWithCompletion:(void (^)(bool))completed
{
    [self syncUserWithCompletion:^(bool status) {
        [self syncSettingsWithCompletion:^(bool status) {
            [self syncCategoriesWithCompletion:^(bool status) {
                [self syncTasksWithCompletion:^(bool status) {
                    [self syncSubTasksWithCompletion:^(bool status) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncCompleted" object:nil];
                        completed(true);
                    }];
                }];
            }];
        }];
    }];
}

-(void)syncUserWithCompletion:(void (^)(bool))completed
{
    [[[UserApiManager alloc] init] syncUserWithCompletion:^(bool status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncUser" object:nil];
        completed(status);
    }];
}

-(void)syncSettingsWithCompletion:(void (^)(bool))completed
{
    [[[SettingsApiManager alloc] init] syncSettingsWithCompletion:^(bool status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncSettings" object:nil];
        completed(status);
    }];
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncCategories" object:nil];
        completed(status);
    }];
}

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    [[[TasksApiManager alloc] init] syncTasksWithCompletion:^(bool status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncTasks" object:nil];
        completed(status);
    }];
}

-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(bool status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncSubTasks" object:nil];
        completed(status);
    }];
}


@end
