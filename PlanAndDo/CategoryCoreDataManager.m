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
            NSUInteger ID = (NSUInteger)[managedCategory valueForKey:@"id"];
            NSString* name = (NSString*)[managedCategory valueForKey:@"category_name"];
            int syncStatus = (int)[managedCategory valueForKey:@"category_sync_status"];

            KSCategory* category = [[KSCategory alloc] initWithID:ID andName:name andSyncStatus:syncStatus];
            
            [categories addObject:category];
        }
    }
    
    return categories;
}

-(void)addCateroty:(KSCategory *)category
{
    NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [object setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
    [object setValue:[category name] forKey:@"category_name"];
    [object setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:@"category_sync_status"];
    [object setValue:[NSNumber numberWithBool:NO] forKey:@"is_deleted"];
    
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
            NSUInteger ID = (NSUInteger)[managedCategory valueForKey:@"id"];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithInteger:category.ID] forKey:@"id"];
                [managedCategory setValue:[category name] forKey:@"category_name"];
                [managedCategory setValue:[NSNumber numberWithInteger:category.syncStatus] forKey:@"category_sync_status"];
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
            NSUInteger ID = (NSUInteger)[managedCategory valueForKey:@"id"];
            if(ID == [category ID])
            {
                [managedCategory setValue:[NSNumber numberWithBool:YES] forKey:@"is_deleted"];
                [self. managedObjectContext save:nil];
            }
            
        }
    }
    
}


@end
