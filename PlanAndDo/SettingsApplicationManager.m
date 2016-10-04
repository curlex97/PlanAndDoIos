//
//  SettingsApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsApplicationManager.h"
#import "ApplicationManager.h"
#import "SyncApplicationManager.h"

@implementation SettingsApplicationManager

-(UserSettings *)settings
{
    return [[[SettingsCoreDataManager alloc] init] settings];
}

-(void)setSettings:(UserSettings *)settings
{
    [[[SettingsCoreDataManager alloc] init] setSettings:settings];
    [[[SyncApplicationManager alloc] init] syncSettingsWithCompletion:^(bool status) {
        [[[SettingsApiManager alloc] init] updateSettingsAsync:settings forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
        }];
    }];
}

-(void)updateSettings:(UserSettings *)settings
{
    [[[SettingsCoreDataManager alloc] init] updateSettings:settings];
    [[[SyncApplicationManager alloc] init] syncSettingsWithCompletion:^(bool status) {
        [[[SettingsApiManager alloc] init] updateSettingsAsync:settings forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
        }];
    }];
}

-(void) cleanTable
{
    return [[[SettingsCoreDataManager alloc] init] cleanTable];
}

@end
