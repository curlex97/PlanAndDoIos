//
//  UserApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSAuthorisedUser.h"
#import "UserApiManager.h"
#import "UserCoreDataManager.h"

@interface UserApplicationManager : NSObject

-(KSAuthorisedUser*) authorisedUser;

-(void)setUser:(KSAuthorisedUser*)user;

-(void)updateUser:(KSAuthorisedUser*)user;

@end
