//
//  SubTasksCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SubTasksCoreDataManager.h"

@implementation SubTasksCoreDataManager

-(NSArray<KSShortTask *> *)allSubTasksForTask:(KSTaskCollection *)task
{
    NSMutableArray* subtasks = [NSMutableArray array];
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if(!error)
    {
        for(NSManagedObject* managedCategory in results)
        {
            NSUInteger taskID = (NSUInteger)[managedCategory valueForKey:@"task_id"];
            if(taskID == [task ID])
            {
                
            }
        }
    }
    
    return subtasks;
}

-(void)addSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    
}

-(void)updateSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{
    
}

-(void)deleteSubTask:(KSShortTask *)subTask forTask:(KSTaskCollection *)task
{

}


@end
