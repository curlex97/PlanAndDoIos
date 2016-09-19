//
//  KSTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSTask.h"

@implementation KSTask

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name
                andStatus:(BOOL)status
      andTaskReminderTime:(NSDate*) taskReminderTime
          andTaskPriority:(KSTaskPriority)priority
            andCategoryID:(int)categoryID
             andCreatedAt:(NSDate*)createdAt
        andCompletionTime:(NSDate*)completionTime
            andSyncStatus:(int)syncStatus
       andTaskDescription:(NSString*)taskDescription
{
    if(self=[super initWithID:ID andName:name andStatus:status andTaskReminderTime:taskReminderTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus])
    {
        self.taskDescription=taskDescription;
    }
    return self;
}

@end
