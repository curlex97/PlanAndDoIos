//
//  SyncApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSAuthorisedUser.h"

@interface SyncApiManager : ApiManager

-(void)syncAsyncForUser:(KSAuthorisedUser*)user completion:(void (^)(bool))completed;

@end
