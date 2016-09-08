//
//  KSTaskCollection.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTask.h"
#import "KSShortTask.h"

@interface KSTaskCollection : BaseTask

@property (nonatomic)NSMutableArray<KSShortTask *> * subTasks;

-(instancetype)initWithTaskName:(NSString *)taskName
                      andStatus:(BOOL)status
                    andIsRemind:(BOOL)remind
                andTaskPriority:(KSTaskPriority)priority
                    andSubTasks:(NSArray<KSShortTask *> *)subTasks;
@end
