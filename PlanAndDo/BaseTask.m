//
//  BaseTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTask.h"

@implementation BaseTask

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority
{
    if(self=[super initWithTaskName:taskName andStatus:status])
    {
        self.isRemind=remind;
        self.priority=priority;
    }
    return self;
}
@end
