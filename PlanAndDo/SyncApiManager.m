//
//  SyncApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 30.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApiManager.h"

@implementation SyncApiManager

-(void)syncStatusWithCompletion:(void (^)(bool))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(true);
    });
}

@end
