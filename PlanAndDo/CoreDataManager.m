//
//  CoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "ApplicationDefines.h"

@implementation CoreDataManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
        NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:CD_DATABASE_NAME withExtension:CD_DATABASE_EXT];
        NSManagedObjectModel* mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        self.managedObjectContext.persistentStoreCoordinator = psc;
        NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* docUrl = urls[urls.count - 1];
        NSURL* storeUrl = [docUrl URLByAppendingPathComponent:CD_DATABASE_SQLITE];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:nil];
    }
    return self;
}


-(void)cleanTable:(NSString *)name
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedObject in results)
        {
            [self.managedObjectContext deleteObject:managedObject];
        }
        [self.managedObjectContext save:nil];
    }
}

@end
