//
//  CategoryCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryCoreDataManager.h"
#import "ApplicationDefines.h"

@implementation CategoryCoreDataManager


-(NSArray<KSCategory *> *)allCategories
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool del = [[managedCategory valueForKey:CD_ROW_IS_DELETED] boolValue];
            
            if(!del)
            {
                int ID = [[managedCategory valueForKey:CD_ROW_ID] intValue];
                NSString* name = (NSString*)[managedCategory valueForKey:CD_ROW_CATEGORY_NAME];
                int syncStatus = [[managedCategory valueForKey:CD_ROW_CATEGORY_SYNC_STATUS] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
                
                [categories addObject:category];
            }
        }
    }
    
    return categories;
}


-(NSArray<KSCategory *> *)allCategoriesForSyncAdd
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool localSync = [[managedCategory valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedCategory valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedCategory valueForKey:CD_ROW_ID] intValue];

            if(!localSync && !del && ID < 0)
            {
                NSString* name = (NSString*)[managedCategory valueForKey:CD_ROW_CATEGORY_NAME];
                int syncStatus = [[managedCategory valueForKey:CD_ROW_CATEGORY_SYNC_STATUS] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
                [categories addObject:category];
            }
        }
    }
    return categories;
}

-(NSArray<KSCategory *> *)allCategoriesForSyncUpdate
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool localSync = [[managedCategory valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedCategory valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedCategory valueForKey:CD_ROW_ID] intValue];
            
            if(!localSync && !del && ID >= 0)
            {
                NSString* name = (NSString*)[managedCategory valueForKey:CD_ROW_CATEGORY_NAME];
                int syncStatus = [[managedCategory valueForKey:CD_ROW_CATEGORY_SYNC_STATUS] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
                [categories addObject:category];
            }
        }
    }
    return categories;
}

-(NSArray<KSCategory *> *)allCategoriesForSyncDelete
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool localSync = [[managedCategory valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            bool del = [[managedCategory valueForKey:CD_ROW_IS_DELETED] boolValue];
            int ID = [[managedCategory valueForKey:CD_ROW_ID] intValue];
            
            if(!localSync && del)
            {
                NSString* name = (NSString*)[managedCategory valueForKey:CD_ROW_CATEGORY_NAME];
                int syncStatus = [[managedCategory valueForKey:CD_ROW_CATEGORY_SYNC_STATUS] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
                [categories addObject:category];
            }
        }
    }
    return categories;
}


-(KSCategory *)categoryWithId:(int)Id
{
    for(KSCategory* category in [self allCategories])
        if(category.ID == Id) return category;
    return nil;
}

-(void)addCateroty:(KSCategory *)category
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_CATEGORY inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [object setValue:[NSNumber numberWithInteger:category.ID] forKey:CD_ROW_ID];
    [object setValue:[category name] forKey:CD_ROW_CATEGORY_NAME];
    [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
    
    [managedObjectContext save:nil];
}

-(void)updateCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:CD_ROW_ID] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithInteger:category.ID] forKey:CD_ROW_ID];
                [managedCategory setValue:[category name] forKey:CD_ROW_CATEGORY_NAME];
                [managedCategory setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
                [managedCategory setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
                
                [self. managedObjectContext save:nil];
            }

        }
    }

}


-(void)deleteCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:CD_ROW_ID] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_IS_DELETED];
                [managedCategory setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
                [managedCategory setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}



// SYNC


-(void)syncAddCateroty:(KSCategory *)category
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_CATEGORY inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [object setValue:[NSNumber numberWithInteger:category.ID] forKey:CD_ROW_ID];
    [object setValue:[category name] forKey:CD_ROW_CATEGORY_NAME];
    [object setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
    [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_IS_DELETED];
    [object setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
    
    [managedObjectContext save:nil];
}

-(void)syncUpdateCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:CD_ROW_ID] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithInteger:category.ID] forKey:CD_ROW_ID];
                [managedCategory setValue:[category name] forKey:CD_ROW_CATEGORY_NAME];
                [managedCategory setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}


-(void)syncDeleteCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_CATEGORY];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:CD_ROW_ID] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_IS_DELETED];
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                [managedCategory setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:CD_ROW_CATEGORY_SYNC_STATUS];
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}


-(void)cleanTable
{
    [super cleanTable:CD_TABLE_CATEGORY];
}


@end
