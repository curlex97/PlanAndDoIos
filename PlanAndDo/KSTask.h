//
//  KSTask.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTask.h"

@interface KSTask : BaseTask

@property (nonatomic)NSString * taskDescription;

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority
                 andDescription:(NSString *)description;
@end
