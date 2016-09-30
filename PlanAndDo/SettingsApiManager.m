//
//  SettingsApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsApiManager.h"

@implementation SettingsApiManager

-(void)updateSettingsAsync:(UserSettings *)settings forUser:(KSAuthorisedUser *)user completion:(void (^)(bool))completed
{
    
}

-(void) syncSettingsWithCompletion:(void (^)(NSDictionary*))completed
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed(nil);
    });
}

@end
