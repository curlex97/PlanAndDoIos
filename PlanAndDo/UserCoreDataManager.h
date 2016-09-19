//
//  UserCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "KSAuthorisedUser.h"

@interface UserCoreDataManager : CoreDataManager

-(KSAuthorisedUser*) authorisedUser;

-(void)setUser:(KSAuthorisedUser*)user;
-(void)updateUser:(KSAuthorisedUser*)user;


@end
