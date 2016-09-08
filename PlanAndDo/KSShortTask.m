//
//  KSShortTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSShortTask.h"

@implementation KSShortTask

-(instancetype)initWithTaskName:(NSString *)taskName andStatus:(BOOL)status
{
    if(self=[super init])
    {
        self.taskName=taskName;
        self.status=status;
    }
    return self;
}
@end
