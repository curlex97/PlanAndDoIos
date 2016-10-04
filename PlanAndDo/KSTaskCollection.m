//
//  KSTaskCollection.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSTaskCollection.h"

@implementation KSTaskCollection

-(instancetype)initWithID:(int)ID andName:(NSString *)name
                andStatus:(BOOL)status
      andTaskReminderTime:(NSDate*) taskReminderTime
          andTaskPriority:(KSTaskPriority)priority
            andCategoryID:(int)categoryID
             andCreatedAt:(NSDate*)createdAt
        andCompletionTime:(NSDate*)completionTime
            andSyncStatus:(int)syncStatus
              andSubTasks:(NSMutableArray<KSShortTask*>*)subTasks
{
    if(self=[super initWithID:ID andName:name andStatus:status andTaskReminderTime:taskReminderTime andTaskPriority:priority andCategoryID:categoryID andCreatedAt:createdAt andCompletionTime:completionTime andSyncStatus:syncStatus])
    {
        self.subTasks= [NSMutableArray arrayWithArray:subTasks];
    }
    return self;
}
@end
