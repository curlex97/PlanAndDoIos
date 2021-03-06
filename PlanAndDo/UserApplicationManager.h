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

@property (nonatomic)KSAuthorisedUser * authorisedUser;
@property (nonatomic)BOOL firstLoad;

-(void)setUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void)updateUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) loginWithEmail:(NSString*)email andPassword:(NSString*)password completion:(void (^)(bool))completed;

-(void) registerAsyncWithEmail:(NSString*)email andUserName:(NSString*)userName andPassword:(NSString*)password completion:(void (^)(bool))completed;

-(void) cleanTable;

-(void) logout;

-(void) recieveUserFromDictionary:(NSDictionary*)dictionary;


@end
