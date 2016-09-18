//
//  KSCategory.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 18.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSCategory.h"

@implementation KSCategory

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name andSyncStatus:(int)syncStatus
{
    self.ID = ID;
    self.name = name;
    self.syncStatus = syncStatus;
    return self;
}

@end
