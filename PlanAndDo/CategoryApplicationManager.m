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
    if(category.ID > 0) category.ID = -category.ID;
    
    [[[CategoryCoreDataManager alloc] init] addCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] addCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncAdd] forUser:[[ApplicationManager userApplicationManager] authorisedUser] completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
}

-(void)updateCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] updateCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncUpdate] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
}

-(void)deleteCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
    
    [[[SyncApplicationManager alloc] init] syncCategoriesWithCompletion:^(bool status) {
        [[[CategoryApiManager alloc] init] deleteCategoriesAsync:[[[CategoryCoreDataManager alloc] init] allCategoriesForSyncDelete] forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
        }];
    }];
    
    NSArray * tasks=[[ApplicationManager tasksApplicationManager] allTasksForCategory:category];
    for (BaseTask * task in tasks)
    {
            [[ApplicationManager tasksApplicationManager] deleteTask:task];
    }
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
                    [[[CategoryCoreDataManager alloc] init] syncAddCateroty:category];
                
                else if(localCategory.syncStatus < category.syncStatus)
                    [[[CategoryCoreDataManager alloc] init] syncUpdateCateroty:category];
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
