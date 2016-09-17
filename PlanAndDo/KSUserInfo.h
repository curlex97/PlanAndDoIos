//
//  KSUserInfo.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSObject.h"

@interface KSUserInfo : KSObject

@property (nonatomic)NSString * userName;
@property (nonatomic)NSString * emailAdress;
@property (nonatomic)NSDate * createdAt;
@property (nonatomic)NSDate * lastVisit;

-(instancetype)initWithUserID:(NSUInteger)ID
                  andUserName:(NSString *)userName
               andEmailAdress:(NSString *)email
              andCreatedDeate:(NSDate *)date
             andLastVisitDate:(NSDate *)visitDate
                andSyncStatus:(int)syncStatus;

@end
