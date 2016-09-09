//
//  BaseTask.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSShortTask.h"

typedef NS_ENUM(NSInteger, KSTaskPriority)
{
    KSTaskDefaultPriority=1,
    KSTaskHighPriority,
    KSTaskVeryHighPriority
};

@interface BaseTask : KSShortTask

@property (nonatomic)BOOL isRemind;
@property (nonatomic)KSTaskPriority priority;

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority;
@end
