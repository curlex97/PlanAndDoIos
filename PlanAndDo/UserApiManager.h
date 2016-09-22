//
//  UserApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSAuthorisedUser.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserApiManager : ApiManager

-(void)updateUserAsync:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

-(void) loginAsyncWithEmail:(NSString*)email andPassword:(NSString*)password completion:(void (^)(bool))completed;

-(void) registerAsyncWithEmail:(NSString*)email andUserName:(NSString*)userName andPassword:(NSString*)password completion:(void (^)(NSDictionary*))completed;

@end
