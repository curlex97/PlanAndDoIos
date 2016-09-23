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

// test 1 OK
-(KSAuthorisedUser*) authorisedUser;

// test 1 OK
-(void)setUser:(KSAuthorisedUser*)user;

// test 1 OK
-(void)updateUser:(KSAuthorisedUser*)user;

-(void)cleanTable;

@end
