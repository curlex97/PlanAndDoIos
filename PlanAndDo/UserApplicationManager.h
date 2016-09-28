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

-(void) loginWithEmail:(NSString*)email andPassword:(NSString*)password completion:(void (^)(bool))completed;

-(void) registerAsyncWithEmail:(NSString*)email andUserName:(NSString*)userName andPassword:(NSString*)password completion:(void (^)(bool))completed;

-(void) cleanTable;

-(void) logout;

@end
