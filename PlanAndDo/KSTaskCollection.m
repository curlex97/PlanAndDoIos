//
//  KSTaskCollection.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSTaskCollection.h"

@implementation KSTaskCollection

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority
                    andSubTasks:(NSArray<KSShortTask *> *)subTasks
{
    if(self=[super initWithTaskName:taskName andStatus:status andIsRemind:remind andTaskPriority:priority])
    {
        self.subTasks= [NSMutableArray arrayWithArray:subTasks];
    }
    return self;
}
@end
