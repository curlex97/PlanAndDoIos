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
    [[[CategoryApiManager alloc] init] addCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser] completion:^(bool status){}];
}

-(void)updateCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[CategoryApiManager alloc] init] updateCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){}];
}

-(void)deleteCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
    [[[CategoryApiManager alloc] init] deleteCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){}];
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
