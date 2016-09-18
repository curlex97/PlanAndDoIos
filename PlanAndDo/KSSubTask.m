//
//  KSSubTask.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 18.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSSubTask.h"

@implementation KSSubTask

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name andTaskID:(NSUInteger)taskID andStatus:(BOOL)status andSyncStatus:(int)syncStatus
{
    if(self = [super initWithID:ID andName:name andStatus:status andSyncStatus:syncStatus])
    {
         self.taskID = taskID;
    }
    return self;
}

@end
