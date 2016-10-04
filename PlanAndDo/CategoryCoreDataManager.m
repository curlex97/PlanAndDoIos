//
//  CategoryCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryCoreDataManager.h"

@implementation CategoryCoreDataManager


-(NSArray<KSCategory *> *)allCategories
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool del = [[managedCategory valueForKey:@"is_deleted"] boolValue];
            
            if(!del)
            {
                NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
                NSString* name = (NSString*)[managedCategory valueForKey:@"category_name"];
                int syncStatus = [[managedCategory valueForKey:@"category_sync_status"] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
                
                [categories addObject:category];
            }
        }
    }
    
    return categories;
}

-(NSArray<KSCategory *> *)allCategoriesForSync
{
    NSMutableArray* categories = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            bool localSync = [[managedCategory valueForKey:@"local_sync"] boolValue];
            
            if(!localSync)
            {
                NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
                NSString* name = (NSString*)[managedCategory valueForKey:@"category_name"];
                int syncStatus = [[managedCategory valueForKey:@"category_sync_status"] intValue];
                
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
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [object setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
    [object setValue:[category name] forKey:@"category_name"];
    [object setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"category_sync_status"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
    
    [managedObjectContext save:nil];
}

-(void)updateCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
                [managedCategory setValue:[category name] forKey:@"category_name"];
                [managedCategory setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"category_sync_status"];
                [managedCategory setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
                
                [self. managedObjectContext save:nil];
            }

        }
    }

}


-(void)deleteCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [managedCategory setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];
                [managedCategory setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"category_sync_status"];
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}



// SYNC


-(void)syncAddCateroty:(KSCategory *)category
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [object setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
    [object setValue:[category name] forKey:@"category_name"];
    [object setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:@"category_sync_status"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
    [object setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
    
    [managedObjectContext save:nil];
}

-(void)syncUpdateCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
                [managedCategory setValue:[category name] forKey:@"category_name"];
                [managedCategory setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:@"category_sync_status"];
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}


-(void)syncDeleteCateroty:(KSCategory *)category
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger ID = [[managedCategory valueForKey:@"id"] integerValue];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                [managedCategory setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:@"category_sync_status"];
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}


-(void)cleanTable
{
    [super cleanTable:@"Category"];
}


@end
