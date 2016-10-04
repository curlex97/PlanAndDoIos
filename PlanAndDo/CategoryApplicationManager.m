//
//  CategoryApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryApplicationManager.h"
#import "ApplicationManager.h"
#import "SyncApplicationManager.h"

@implementation CategoryApplicationManager

-(NSArray<KSCategory *> *)allCategories
{
    return [[[CategoryCoreDataManager alloc] init] allCategories];
}

-(KSCategory *)categoryWithId:(int)Id
{
    return [[[CategoryCoreDataManager alloc] init] categoryWithId:Id];
}

-(void)addCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] addCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] addCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser] completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
}

-(void)updateCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] updateCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
}

-(void)deleteCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
    
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] deleteCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSync] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
    
    NSArray * tasks=[[ApplicationManager tasksApplicationManager] allTasksForCategory:category];
    for (BaseTask * task in tasks)
    {
            [[ApplicationManager tasksApplicationManager] deleteTask:task];
    }
}

-(void) cleanTable
{
    return [[[CategoryCoreDataManager alloc] init] cleanTable];
}

@end
