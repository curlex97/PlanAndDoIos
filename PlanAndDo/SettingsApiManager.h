//
//  SettingsApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSAuthorisedUser.h"
#import "UserSettings.h"

@interface SettingsApiManager : ApiManager

-(void)updateSettingsAsync:(UserSettings*)settings forUser:(KSAuthorisedUser*)user completion:(void (^)(NSDictionary*))completed;


-(void) syncSettingsWithCompletion:(void (^)(NSDictionary*))completed;


@end
