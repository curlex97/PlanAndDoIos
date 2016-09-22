//
//  KSAuthorisedUser.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSUserInfo.h"
#import "UserSettings.h"



@interface KSAuthorisedUser : KSUserInfo
@property (nonatomic)NSString * apiToken;
@property (nonatomic)UserSettings * settings;


-(instancetype)initWithUserID:(NSUInteger)ID
                  andUserName:(NSString *)userName
               andEmailAdress:(NSString *)email
              andCreatedDeate:(NSDate *)date
             andLastVisitDate:(NSDate *)visitDate
                andSyncStatus:(int)syncStatus
               andAccessToken:(NSString *)token
              andUserSettings:(UserSettings *)settings;

+(KSAuthorisedUser*) currentUser;

@end
