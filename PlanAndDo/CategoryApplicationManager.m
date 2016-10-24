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
#import "KSCategory.h"

@implementation CategoryApplicationManager

-(NSArray<KSCategory *> *)allCategories
{
    return [[[CategoryCoreDataManager alloc] init] allCategories];
}

-(KSCategory *)categoryWithId:(int)Id
{
    return [[[CategoryCoreDataManager alloc] init] categoryWithId:Id];
}

-(void)addCateroty:(KSCategory *)category completion:(void (^)(bool))completed
{
    if(category.ID > 0)
    {
        category.ID = -category.ID;
    }
    
    [[[CategoryCoreDataManager alloc] init] addCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status)
    {
        if(status)
        {
            [[[CategoryApiManager alloc] init] addCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncAdd] forUser:[[ApplicationManager sharedApplication].userApplicationManager authorisedUser] completion:^(NSDictionary* dictionary)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    NSLog(@"%@",dictionary);
                    NSArray * categories=[dictionary objectForKey:@"data"];
                    for(NSDictionary * cat in categories)
                    {
                        int catID = [[cat valueForKeyPath:@"id"] intValue];
                        NSString* catName = [cat valueForKeyPath:@"category_name"];
                        int syncStatus = [[cat valueForKeyPath:@"category_sync_status"] intValue];
                        [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
                        [[[CategoryCoreDataManager alloc] init] syncAddCateroty:[[KSCategory alloc] initWithID:catID andName:catName andSyncStatus:syncStatus]];
                    }
                    if(completed)
                    {
                        completed(YES);
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
                });
            }];
        }
    }];
}

-(void)updateCateroty:(KSCategory *)category completion:(void (^)(bool))completed
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status)
    {
        if(status)
        {
            [[[CategoryApiManager alloc] init] updateCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncUpdate] forUser:  [[ApplicationManager sharedApplication].userApplicationManager authorisedUser]  completion:^(NSDictionary* dictionary)
            {
                if(completed) completed(YES);
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
            }];
        }
    }];
}

-(void)deleteCateroty:(KSCategory *)category completion:(void (^)(bool))completed
{
    NSArray * tasks=[[ApplicationManager sharedApplication].tasksApplicationManager allTasksForCategory:category];
    for (BaseTask * task in tasks)
    {
        [[ApplicationManager sharedApplication].tasksApplicationManager deleteTask:task completion:nil];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
        [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status)
         {
             if(status)
             {
                 [[[CategoryApiManager alloc] init] deleteCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncDelete] forUser:[[ApplicationManager sharedApplication].userApplicationManager authorisedUser]  completion:^(NSDictionary* dictionary)
                  {
                      if(completed) completed(YES);
                      [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
                }];
             }
         }];
    });
}

-(void)recieveCategoriesFromDictionary:(NSDictionary *)dictionary
{
    NSString* status = [dictionary valueForKeyPath:@"status"];
    
    if([status containsString:@"suc"])
    {
        
        NSArray* defCats = (NSArray*)[dictionary valueForKeyPath:@"data"];
        for(NSDictionary* defaultCategory in defCats)
        {
            int catID = [[defaultCategory valueForKeyPath:@"id"] intValue];
            NSString* catName = [defaultCategory valueForKeyPath:@"category_name"];
            int syncStatus = [[defaultCategory valueForKeyPath:@"category_sync_status"] intValue];
            
            bool isDeleted = [[defaultCategory valueForKeyPath:@"is_deleted"] intValue] > 0;
            
            [SyncApplicationManager updateLastSyncTime:syncStatus];
            
            KSCategory* category = [[KSCategory alloc] initWithID:catID andName:catName andSyncStatus:syncStatus];
            
            KSCategory* localCategory = [[[CategoryCoreDataManager alloc] init] categoryWithId:(int)category.ID];
            
            
            if(!isDeleted)
            {
                if(!localCategory)
                {
                    [[[CategoryCoreDataManager alloc] init] syncAddCateroty:category];
                }
                else if(localCategory.syncStatus < category.syncStatus)
                {
                    [[[CategoryCoreDataManager alloc] init] syncUpdateCateroty:category];
                }
            }
            else [[[CategoryCoreDataManager alloc] init] syncDeleteCateroty:category];
        }
    }
}

-(void) cleanTable
{
    return [[[CategoryCoreDataManager alloc] init] cleanTable];
}

@end
