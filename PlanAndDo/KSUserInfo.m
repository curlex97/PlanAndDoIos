//
//  KSUserInfo.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSUserInfo.h"

@implementation KSUserInfo

-(instancetype)initWithUserID:(NSUInteger)ID
                  andUserName:(NSString *)userName
               andEmailAdress:(NSString *)email
              andCreatedDeate:(NSDate *)date
             andLastVisitDate:(NSDate *)visitDate andSyncStatus:(int)syncStatus
{
    if(self=[super init])
    {
        self.ID=ID;
        self.userName=userName;
        self.emailAdress=email;
        self.createdAt=date;
        self.lastVisit=visitDate;
        self.syncStatus = syncStatus;
    }
    return self;
}
@end
