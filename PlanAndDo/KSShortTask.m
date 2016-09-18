//
//  KSShortTask.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSShortTask.h"

@implementation KSShortTask

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name andStatus:(BOOL)status  andSyncStatus:(int)syncStatus
{
    if(self=[super init])
    {
        self.ID = ID;
        self.name=name;
        self.status=status;
        self.syncStatus = syncStatus;
    }
    return self;
}
@end
