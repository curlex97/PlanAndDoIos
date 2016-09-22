//
//  SettingsApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsApplicationManager.h"

@implementation SettingsApplicationManager

-(UserSettings *)settings
{
    return [[[SettingsCoreDataManager alloc] init] settings];
}

-(void)setSettings:(UserSettings *)settings
{
    [[[SettingsCoreDataManager alloc] init] setSettings:settings];
    [[[SettingsApiManager alloc] init] updateSettingsAsync:settings forUser:nil completion:nil];
}

-(void)updateSettings:(UserSettings *)settings
{
    [[[SettingsCoreDataManager alloc] init] updateSettings:settings];
    [[[SettingsApiManager alloc] init] updateSettingsAsync:settings forUser:nil completion:nil];
}

@end
