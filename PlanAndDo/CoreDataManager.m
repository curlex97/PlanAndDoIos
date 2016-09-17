//
//  CoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

-(NSManagedObjectContext *)managedObjectContext
{
    if(!managedObjectContext)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
        NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"PlanAndDo" withExtension:@"momd"];
        NSManagedObjectModel* mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        managedObjectContext.persistentStoreCoordinator = psc;
        NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* docUrl = urls[urls.count - 1];
        NSURL* storeUrl = [docUrl URLByAppendingPathComponent:@"PlanAndDo.sqlite"];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:nil];
    }
    return managedObjectContext;
}


-(NSArray *)fetch:(NSString *)table
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:table];
    NSArray* results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return error ? results : nil;
}

@end
