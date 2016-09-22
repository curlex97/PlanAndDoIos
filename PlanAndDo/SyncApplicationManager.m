//
//  SyncApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApplicationManager.h"

@implementation SyncApplicationManager

-(void)sync
{
    [[[SyncApiManager alloc] init] syncAsyncForUser:nil];
}

@end
