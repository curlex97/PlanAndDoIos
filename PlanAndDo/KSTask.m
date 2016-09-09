//
//  KSTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSTask.h"

@implementation KSTask

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority
                 andDescription:(NSString *)description
{
    if(self=[super initWithTaskName:taskName andStatus:status andIsRemind:remind andTaskPriority:priority])
    {
        self.taskDescription=description;
    }
    return self;
}

@end
