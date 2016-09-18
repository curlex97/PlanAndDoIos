//
//  CoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
        NSURL* modelUrl = [[NSBundle mainBundle] URLForResource:@"PlanAndDo" withExtension:@"momd"];
        NSManagedObjectModel* mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        self.managedObjectContext.persistentStoreCoordinator = psc;
        NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* docUrl = urls[urls.count - 1];
        NSURL* storeUrl = [docUrl URLByAppendingPathComponent:@"PlanAndDo.sqlite"];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:nil];
    }
    return self;
}




@end
