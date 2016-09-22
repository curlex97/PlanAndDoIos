//
//  KSAuthorisedUser.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSAuthorisedUser.h"

static KSAuthorisedUser* currentUser;

@implementation KSAuthorisedUser

-(instancetype)initWithUserID:(NSUInteger)ID
                  andUserName:(NSString *)userName
               andEmailAdress:(NSString *)email
              andCreatedDeate:(NSDate *)date
             andLastVisitDate:(NSDate *)visitDate
                andSyncStatus:(int)syncStatus
               andAccessToken:(NSString *)token
              andUserSettings:(UserSettings *)settings
{
    if(self=[super initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:date andLastVisitDate:visitDate andSyncStatus:syncStatus])
    {
        static BOOL initialized = NO;
        if(!initialized)
        {
            initialized = YES;
            self.apiToken=token;
            self.settings=settings;
            currentUser = self;
        }
      
    }
    return currentUser;
}

+(KSAuthorisedUser *)currentUser
{
    return currentUser;
}

@end
