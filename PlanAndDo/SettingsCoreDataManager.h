//
//  SettingsCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "UserSettings.h"


@interface SettingsCoreDataManager : CoreDataManager

-(UserSettings*) settings;

-(void)updateSettings:(UserSettings*)settings;

@end
