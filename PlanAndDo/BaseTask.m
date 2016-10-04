//
//  BaseTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTask.h"

@implementation BaseTask

-(instancetype)initWithID:(int)ID andName:(NSString *)name
                andStatus:(BOOL)status
      andTaskReminderTime:(NSDate*) taskReminderTime
          andTaskPriority:(KSTaskPriority)priority
            andCategoryID:(int)categoryID
             andCreatedAt:(NSDate*)createdAt
        andCompletionTime:(NSDate*)completionTime
            andSyncStatus:(int)syncStatus
{
    if(self=[super initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus])
    {
        self.isRemind = taskReminderTime ? YES : NO;
        self.taskReminderTime = taskReminderTime;
        self.priority=priority;
        self.categoryID = categoryID;
        self.createdAt = createdAt;
        self.completionTime = completionTime;
    }
    return self;
}
@end
