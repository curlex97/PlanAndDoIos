//
//  TasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TasksCoreDataManager.h"

@implementation TasksCoreDataManager


-(NSArray<BaseTask *> *)allTasks
{
    NSMutableArray<BaseTask*>* tasks = [NSMutableArray array];
    NSArray* fetchedResults =  [self fetch:@"Task"];
    if(fetchedResults)
    {
        for(NSManagedObject* managedTask in fetchedResults)
        {
            int task_type = [[managedTask valueForKey:@"task_type"] intValue];
            if(!task_type)
            {
                KSTask* task = [[KSTask alloc] initWithTaskName:[managedTask valueForKey:@""] andStatus:[managedTask valueForKey:@""] andIsRemind:[managedTask valueForKey:@""] andTaskPriority:[managedTask valueForKey:@""] andDescription:[managedTask valueForKey:@""] andSyncStatus:[[managedTask valueForKey:@""] intValue]];
            }
            
        }
    }
    
    return tasks;
}


/*
 let managedContext = DataController().managedObjectContext
 let fetchRequest = NSFetchRequest(entityName: "HistoryProduct")
 let results = managedContext.executeFetchRequest(fetchRequest)
 let historyProducts = results as! [NSManagedObject]
 */

/*
 let managedContext = DataController().managedObjectContext
 let entity =  NSEntityDescription.entityForName("HistoryProduct", inManagedObjectContext:managedContext)
 let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
 person.setValue(product.name, forKey: "name")
 */

@end
