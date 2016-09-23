//
//  SettingsApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettings.h"
#import "SettingsApiManager.h"
#import "SettingsCoreDataManager.h"

@interface SettingsApplicationManager : NSObject

-(UserSettings*) settings;

-(void)setSettings:(UserSettings*)settings;

-(void)updateSettings:(UserSettings*)settings;

-(void) cleanTable;

@end
