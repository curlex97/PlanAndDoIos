//
//  UserApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserApplicationManager.h"

@implementation UserApplicationManager

-(KSAuthorisedUser *)authorisedUser
{
    return [[[UserCoreDataManager alloc] init] authorisedUser];
}

-(void)setUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] setUser:user];
    [[[UserApiManager alloc] init] updateUserAsync:user];
}

-(void)updateUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] updateUser:user];
    [[[UserApiManager alloc] init] updateUserAsync:user];
}

@end
