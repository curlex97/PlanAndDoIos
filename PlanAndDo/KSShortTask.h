//
//  KSShortTask.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSObject.h"

@interface KSShortTask : KSObject

@property (nonatomic)NSString * taskName;
@property (nonatomic)BOOL status;

-(instancetype)initWithTaskName:(NSString *)taskName andStatus:(BOOL)status;
@end
